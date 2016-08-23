Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-wm0-f68.google.com ([74.125.82.68]:34291 "EHLO
        mail-wm0-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1753210AbcHWJaP (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Tue, 23 Aug 2016 05:30:15 -0400
Subject: Re: [PATCH 1/1] brcmfmac: fix pmksa->bssid usage
To: Arend Van Spriel <arend.vanspriel@broadcom.com>,
        Franky Lin <franky.lin@broadcom.com>,
        Hante Meuleman <hante.meuleman@broadcom.com>,
        linux-wireless@vger.kernel.org, brcm80211-dev-list.pdl@broadcom.com
References: <20160805203418.32162-1-nicolas.iooss_linux@m4x.org>
 <96ea6e57-79d7-d4ff-1228-6f22addd4996@m4x.org>
 <45617c4f-60b9-2587-5e29-6330ba2f40a6@broadcom.com>
Cc: netdev@vger.kernel.org, linux-kernel@vger.kernel.org
From: Nicolas Iooss <nicolas.iooss_linux@m4x.org>
Message-ID: <7fc849f7-c178-d13e-e9cf-d107a9f73c61@m4x.org> (sfid-20160823_113203_305901_E80DBE2F)
Date: Tue, 23 Aug 2016 11:30:12 +0200
MIME-Version: 1.0
In-Reply-To: <45617c4f-60b9-2587-5e29-6330ba2f40a6@broadcom.com>
Content-Type: text/plain; charset=windows-1252
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 22/08/16 21:38, Arend Van Spriel wrote:
> On 22-8-2016 15:03, Nicolas Iooss wrote:
>> On 05/08/16 22:34, Nicolas Iooss wrote:
[...]
>>> Fixes: 6c404f34f2bd ("brcmfmac: Cleanup pmksa cache handling code")
>>> Cc: stable@ger.kernel.org
> 
> Ah, so you did something wrong after all :-p. The email address should
> be 'stable@vger.kernel.org'.

Thanks for spotting this! I'll fix this address.

>>> Signed-off-by: Nicolas Iooss <nicolas.iooss_linux@m4x.org>
>>> ---
>>>
>>> scripts/checkpatch.pl reports a warning: "Prefer ether_addr_equal() or
>>> ether_addr_equal_unaligned() over memcmp()".  Because some files in
>>> drivers/net/wireless/broadcom/brcm80211/brcmfmac/ still use memcmp()
>>> to compare addresses and because I do not know whether pmksa->bssid is
>>> always aligned, I did not follow this warning.
> 
> As most of this is done in slow path, I prefer memcmp() as I do not want
> to check alignment for minimal performance gain.

OK.

>>>  drivers/net/wireless/broadcom/brcm80211/brcmfmac/cfg80211.c | 4 ++--
>>>  1 file changed, 2 insertions(+), 2 deletions(-)
>>>
>>> diff --git a/drivers/net/wireless/broadcom/brcm80211/brcmfmac/cfg80211.c b/drivers/net/wireless/broadcom/brcm80211/brcmfmac/cfg80211.c
>>> index 2628d5e12c64..aceab77cd95a 100644
>>> --- a/drivers/net/wireless/broadcom/brcm80211/brcmfmac/cfg80211.c
>>> +++ b/drivers/net/wireless/broadcom/brcm80211/brcmfmac/cfg80211.c
>>> @@ -3884,11 +3884,11 @@ brcmf_cfg80211_del_pmksa(struct wiphy *wiphy, struct net_device *ndev,
>>>  	if (!check_vif_up(ifp->vif))
>>>  		return -EIO;
>>>  
>>> -	brcmf_dbg(CONN, "del_pmksa - PMK bssid = %pM\n", &pmksa->bssid);
>>> +	brcmf_dbg(CONN, "del_pmksa - PMK bssid = %pM\n", pmksa->bssid);
>>>  
>>>  	npmk = le32_to_cpu(cfg->pmk_list.npmk);
>>>  	for (i = 0; i < npmk; i++)
>>> -		if (!memcmp(&pmksa->bssid, &pmk[i].bssid, ETH_ALEN))
>>> +		if (!memcmp(pmksa->bssid, &pmk[i].bssid, ETH_ALEN))
> 
> I find '&pmk[i].bssid' confusing so maybe you could change it to
> '&pmk[i].bssid[0]' or 'pmk[i].bssid' as I think these two are
> essentially the same.

I agree the three ways of writing this share the same meaning. I'll send
a v2 with 'pmk[i].bssid'.
> 
> Regards,
> Arend

Thanks for your review!
Nicolas
