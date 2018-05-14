Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from 11.mo5.mail-out.ovh.net ([46.105.47.167]:45773 "EHLO
        11.mo5.mail-out.ovh.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751198AbeENFuk (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Mon, 14 May 2018 01:50:40 -0400
Received: from player770.ha.ovh.net (unknown [10.109.108.79])
        by mo5.mail-out.ovh.net (Postfix) with ESMTP id 67C741A86D4
        for <linux-wireless@vger.kernel.org>; Mon, 14 May 2018 07:11:13 +0200 (CEST)
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8;
 format=flowed
Date: Mon, 14 May 2018 07:11:01 +0200
From: =?UTF-8?Q?Rafa=C5=82_Mi=C5=82ecki?= <rafal@milecki.pl>
To: Arend van Spriel <arend.vanspriel@broadcom.com>
Cc: =?UTF-8?Q?Rafa=C5=82_Mi=C5=82ecki?= <zajec5@gmail.com>,
        Kalle Valo <kvalo@codeaurora.org>,
        Franky Lin <franky.lin@broadcom.com>,
        Hante Meuleman <hante.meuleman@broadcom.com>,
        Chi-Hsien Lin <chi-hsien.lin@cypress.com>,
        Wright Feng <wright.feng@cypress.com>,
        Pieter-Paul Giesberts <pieter-paul.giesberts@broadcom.com>,
        linux-wireless@vger.kernel.org,
        brcm80211-dev-list.pdl@broadcom.com, brcm80211-dev-list@cypress.com
Subject: Re: [PATCH] brcmfmac: add debugfs entry for reading firmware
 capabilities
In-Reply-To: <5AF88B10.2040504@broadcom.com>
References: <20180511101526.10734-1-zajec5@gmail.com>
 <5AF88B10.2040504@broadcom.com>
Message-ID: <5729429a82d2eb034b88adb7e1738ce6@milecki.pl> (sfid-20180514_075044_648507_ADBB9BCB)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 2018-05-13 20:59, Arend van Spriel wrote:
> On 5/11/2018 12:15 PM, Rafał Miłecki wrote:
>> From: Rafał Miłecki <rafal@milecki.pl>
>> 
>> This allows reading all capabilities as reported by a firmware. They 
>> are
>> printed using native (raw) names, just like developers like it the 
>> most.
>> It's how firmware reports support for various features, e.g. supported
>> modes, supported standards, power saving details, max BSS-es.
>> 
>> Access to all that info is useful for trying new firmwares, comparing
>> them and debugging features AKA bugs.
> 
> What are you implying :-p ? Some comments below.

;) For real I was trying to figure out supported modes. It appears e.g.
many/most firmwares support up to 8 MBSS ("mbss8") while brcmfmac allows
up to 4 only.

> Reviewed-by: Arend van Spriel <arend.vanspriel@broadcom.com>
>> Signed-off-by: Rafał Miłecki <rafal@milecki.pl>
>> ---
>>   .../wireless/broadcom/brcm80211/brcmfmac/feature.c | 36 
>> ++++++++++++++++++++++
>>   1 file changed, 36 insertions(+)
>> 
>> diff --git 
>> a/drivers/net/wireless/broadcom/brcm80211/brcmfmac/feature.c 
>> b/drivers/net/wireless/broadcom/brcm80211/brcmfmac/feature.c
>> index 876731c57bf5..782121cb9399 100644
>> --- a/drivers/net/wireless/broadcom/brcm80211/brcmfmac/feature.c
>> +++ b/drivers/net/wireless/broadcom/brcm80211/brcmfmac/feature.c
>> @@ -165,6 +165,41 @@ static void 
>> brcmf_feat_firmware_capabilities(struct brcmf_if *ifp)
>>   	}
>>   }
>> 
>> +/**
>> + * brcmf_cap_read() - expose firmware capabilities to debugfs.
> 
> Please stick to naming convention brcmf_<module>_foo(), ie.
> brcmf_feat_cap_read().

Will do, thanks! I missed that naming convention because of
brcmf_debugfs_fws_stats_read() / brcmf_debugfs_sdio_count_read() which
slightly confused me. I see your point now!

>> + *
>> + * @seq: sequence for debugfs entry.
>> + * @data: raw data pointer.
>> + */
>> +static int brcmf_cap_read(struct seq_file *seq, void *data)
>> +{
>> +	struct brcmf_bus *bus_if = dev_get_drvdata(seq->private);
>> +	struct brcmf_if *ifp = brcmf_get_ifp(bus_if->drvr, 0);
>> +	char caps[MAX_CAPS_BUFFER_SIZE + 1] = { };
>> +	char *tmp;
>> +	int err;
>> +
>> +	err = brcmf_fil_iovar_data_get(ifp, "cap", caps, sizeof(caps));
>> +	if (err) {
>> +		brcmf_err("could not get firmware cap (%d)\n", err);
>> +		return err;
>> +	}
>> +
>> +	/* Put every capability in a new line */
>> +	for (tmp = caps; *tmp; tmp++) {
>> +		if (*tmp == ' ')
>> +			*tmp = '\n';
>> +	}
>> +
>> +	/* Usually there is a space at the end of capabilities string */
>> +	seq_printf(seq, "%s", caps);
>> +	/* So make sure we don't print two line breaks */
>> +	if (tmp > caps && *(tmp - 1) != '\n')
>> +		seq_printf(seq, "\n");
>> +
>> +	return 0;
>> +}
>> +
>>   void brcmf_feat_attach(struct brcmf_pub *drvr)
>>   {
>>   	struct brcmf_if *ifp = brcmf_get_ifp(drvr, 0);
>> @@ -233,6 +268,7 @@ void brcmf_feat_attach(struct brcmf_pub *drvr)
>>   void brcmf_feat_debugfs_create(struct brcmf_pub *drvr)
>>   {
>>   	brcmf_debugfs_add_entry(drvr, "features", brcmf_feat_debugfs_read);
>> +	brcmf_debugfs_add_entry(drvr, "cap", brcmf_cap_read);
> 
> Prefer to name the debugfs entry "fwcap".

Sure.
