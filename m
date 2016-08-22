Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-wm0-f65.google.com ([74.125.82.65]:36310 "EHLO
        mail-wm0-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S932349AbcHVNED (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Mon, 22 Aug 2016 09:04:03 -0400
Subject: Re: [PATCH 1/1] brcmfmac: fix pmksa->bssid usage
To: Arend van Spriel <arend.vanspriel@broadcom.com>,
        Franky Lin <franky.lin@broadcom.com>,
        Hante Meuleman <hante.meuleman@broadcom.com>,
        linux-wireless@vger.kernel.org, brcm80211-dev-list.pdl@broadcom.com
References: <20160805203418.32162-1-nicolas.iooss_linux@m4x.org>
Cc: netdev@vger.kernel.org, linux-kernel@vger.kernel.org
From: Nicolas Iooss <nicolas.iooss_linux@m4x.org>
Message-ID: <96ea6e57-79d7-d4ff-1228-6f22addd4996@m4x.org> (sfid-20160822_150422_162269_8DB7EB5A)
Date: Mon, 22 Aug 2016 15:03:59 +0200
MIME-Version: 1.0
In-Reply-To: <20160805203418.32162-1-nicolas.iooss_linux@m4x.org>
Content-Type: text/plain; charset=windows-1252
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hello,

After I sent the following patch a few weeks ago, I have not received
any feedback. Could you please review it and tell me what I may have
done wrong?

Thanks,
Nicolas

On 05/08/16 22:34, Nicolas Iooss wrote:
> The struct cfg80211_pmksa defines its bssid field as:
> 
>     const u8 *bssid;
> 
> contrary to struct brcmf_pmksa, which uses:
> 
>     u8 bssid[ETH_ALEN];
> 
> Therefore in brcmf_cfg80211_del_pmksa(), &pmksa->bssid takes the address
> of this field (of type u8**), not the one of its content (which would be
> u8*).  Remove the & operator to make brcmf_dbg("%pM") and memcmp()
> behave as expected.
> 
> This bug have been found using a custom static checker (which checks the
> usage of %p... attributes at build time).  It has been introduced in
> commit 6c404f34f2bd ("brcmfmac: Cleanup pmksa cache handling code"),
> which replaced pmksa->bssid by &pmksa->bssid while refactoring the code,
> without modifying struct cfg80211_pmksa definition.
> 
> Fixes: 6c404f34f2bd ("brcmfmac: Cleanup pmksa cache handling code")
> Cc: stable@ger.kernel.org
> Signed-off-by: Nicolas Iooss <nicolas.iooss_linux@m4x.org>
> ---
> 
> scripts/checkpatch.pl reports a warning: "Prefer ether_addr_equal() or
> ether_addr_equal_unaligned() over memcmp()".  Because some files in
> drivers/net/wireless/broadcom/brcm80211/brcmfmac/ still use memcmp()
> to compare addresses and because I do not know whether pmksa->bssid is
> always aligned, I did not follow this warning.
> 
>  drivers/net/wireless/broadcom/brcm80211/brcmfmac/cfg80211.c | 4 ++--
>  1 file changed, 2 insertions(+), 2 deletions(-)
> 
> diff --git a/drivers/net/wireless/broadcom/brcm80211/brcmfmac/cfg80211.c b/drivers/net/wireless/broadcom/brcm80211/brcmfmac/cfg80211.c
> index 2628d5e12c64..aceab77cd95a 100644
> --- a/drivers/net/wireless/broadcom/brcm80211/brcmfmac/cfg80211.c
> +++ b/drivers/net/wireless/broadcom/brcm80211/brcmfmac/cfg80211.c
> @@ -3884,11 +3884,11 @@ brcmf_cfg80211_del_pmksa(struct wiphy *wiphy, struct net_device *ndev,
>  	if (!check_vif_up(ifp->vif))
>  		return -EIO;
>  
> -	brcmf_dbg(CONN, "del_pmksa - PMK bssid = %pM\n", &pmksa->bssid);
> +	brcmf_dbg(CONN, "del_pmksa - PMK bssid = %pM\n", pmksa->bssid);
>  
>  	npmk = le32_to_cpu(cfg->pmk_list.npmk);
>  	for (i = 0; i < npmk; i++)
> -		if (!memcmp(&pmksa->bssid, &pmk[i].bssid, ETH_ALEN))
> +		if (!memcmp(pmksa->bssid, &pmk[i].bssid, ETH_ALEN))
>  			break;
>  
>  	if ((npmk > 0) && (i < npmk)) {
> 
