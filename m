Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-gw2-out.broadcom.com ([216.31.210.63]:38413 "EHLO
	mail-gw2-out.broadcom.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751365AbaFXRLs (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 24 Jun 2014 13:11:48 -0400
Message-ID: <53A9B152.5050503@broadcom.com> (sfid-20140624_191152_638781_FCB45761)
Date: Tue, 24 Jun 2014 19:11:46 +0200
From: Arend van Spriel <arend@broadcom.com>
MIME-Version: 1.0
To: Johannes Berg <johannes@sipsolutions.net>
CC: "John W. Linville" <linville@tuxdriver.com>,
	linux-wireless <linux-wireless@vger.kernel.org>,
	"Luis R. Rodriguez" <mcgrof@do-not-panic.com>
Subject: Re: [RFC 3/3] brcmfmac: update band and regulatory info before wiphy_register()
References: <1402996581-10764-1-git-send-email-arend@broadcom.com>	 <1402996581-10764-4-git-send-email-arend@broadcom.com> <1403516273.4418.11.camel@jlt4.sipsolutions.net>
In-Reply-To: <1403516273.4418.11.camel@jlt4.sipsolutions.net>
Content-Type: text/plain; charset="UTF-8"; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 23-06-14 11:37, Johannes Berg wrote:
> I'm not really sure why this code requires the previous patch?
>
>> @@ -5615,35 +5593,51 @@ struct brcmf_cfg80211_info *brcmf_cfg80211_attach(struct brcmf_pub *drvr,
>>   	err = wl_init_priv(cfg);
>>   	if (err) {
>>   		brcmf_err("Failed to init iwm_priv (%d)\n", err);
>> -		goto cfg80211_attach_out;
>> +		brcmf_free_vif(vif);
>> +		goto wiphy_out;
>>   	}
>>   	ifp->vif = vif;
>>
>> +	if (wiphy_is_40mhz_24ghz_disabled(wiphy) == false) {
>> +		err = brcmf_enable_bw40_2g(ifp);
>> +		if (!err)
>> +			err = brcmf_fil_iovar_int_set(ifp, "obss_coex",
>> +						      BRCMF_OBSS_COEX_AUTO);
>> +	}
>
> This seems to have an effect only on the device, so why not do it after
> wiphy_register()?

It does affect channels list in brcmf_update_wiphybands().

>> +	/* determine d11 io type before updating bands */
>> +	err = brcmf_fil_cmd_int_get(ifp, BRCMF_C_GET_VERSION, &io_type);
>> +	if (err) {
>> +		brcmf_err("Failed to get D11 version (%d)\n", err);
>> +		goto priv_out;
>> +	}
>> +	cfg->d11inf.io_type = (u8)io_type;
>> +	brcmu_d11_attach(&cfg->d11inf);
>> +
>> +	err = brcmf_update_wiphybands(cfg);
>> +	if (err)
>> +		goto priv_out;
>> +
>> +	brcmf_dbg(INFO, "Registering custom regulatory\n");
>> +	wiphy->regulatory_flags |= REGULATORY_CUSTOM_REG;
>> +	wiphy_apply_custom_regulatory(wiphy, &brcmf_regdom);
>
> The regdomain is also static const so not affected by it.

Digging further in this code, I found that the brcmf_update_wiphybands() 
queries the device to get the actual list of channels, which 
subsequently is determined by the 40MHz setting in the 2G band. Not so 
much for the channel itself as for the flags. If that is all done after 
wiphy_apply_custom_regulatory() it does not show up when doing 'iw phy 
info'. And according to the documentation that call needs to be done 
before wiphy_register().

In the current code the wiphy_apply_custom_regulatory() is called twice 
(before and after wiphy_register()) which seems to do the trick, but in 
that it might be exploiting unintended behaviour. Hence the attempt to 
change the order of things.

Regards,
Arend

