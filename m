Return-Path: <SRS0=80NG=P2=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.8 required=3.0 tests=DKIM_INVALID,DKIM_SIGNED,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_PASS,
	USER_AGENT_NEOMUTT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 3BA99C1B0FD
	for <linux-wireless@archiver.kernel.org>; Fri, 18 Jan 2019 22:12:01 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id DCED32086D
	for <linux-wireless@archiver.kernel.org>; Fri, 18 Jan 2019 22:12:00 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="signature verification failed" (1024-bit key) header.d=armlinux.org.uk header.i=@armlinux.org.uk header.b="oy3dZHRx"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729878AbfARWMA (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Fri, 18 Jan 2019 17:12:00 -0500
Received: from pandora.armlinux.org.uk ([78.32.30.218]:35938 "EHLO
        pandora.armlinux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729621AbfARWMA (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Fri, 18 Jan 2019 17:12:00 -0500
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=armlinux.org.uk; s=pandora-2014; h=Sender:In-Reply-To:Content-Type:
        MIME-Version:References:Message-ID:Subject:Cc:To:From:Date:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description:Resent-Date:
        Resent-From:Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:List-Id:
        List-Help:List-Unsubscribe:List-Subscribe:List-Post:List-Owner:List-Archive;
         bh=LpyYT9CB4Ac8036Jmv/Rm6eS5ssxr8NZqeFtsCA+eAY=; b=oy3dZHRxE3BEL+loMWjAgpG07
        a/U95LiDP0d3WSyxQWSLPD9SH+sJlw8PUborT/sa3IfBhvQv7b2yhcl3VntNNbpF5cvxcf5dtU+Fx
        NEGeyCSdO9xsiJlIRk+6zBmPiP1AfNdW6JpZHXRmbd5hbU3HtoaZ/2V9mFopwQBlVE4a0=;
Received: from e5254000004ec.dyn.armlinux.org.uk ([2001:4d48:ad52:3201:5054:ff:fe00:4ec]:37888 helo=shell.armlinux.org.uk)
        by pandora.armlinux.org.uk with esmtpsa (TLSv1.2:ECDHE-RSA-AES256-GCM-SHA384:256)
        (Exim 4.90_1)
        (envelope-from <linux@armlinux.org.uk>)
        id 1gkcMl-0001t6-I8; Fri, 18 Jan 2019 22:11:55 +0000
Received: from linux by shell.armlinux.org.uk with local (Exim 4.89)
        (envelope-from <linux@shell.armlinux.org.uk>)
        id 1gkcMk-0002DN-VZ; Fri, 18 Jan 2019 22:11:54 +0000
Date:   Fri, 18 Jan 2019 22:11:54 +0000
From:   Russell King - ARM Linux admin <linux@armlinux.org.uk>
To:     Arend van Spriel <arend.vanspriel@broadcom.com>
Cc:     Kalle Valo <kvalo@codeaurora.org>, linux-wireless@vger.kernel.org,
        brcm80211-dev-list.pdl@broadcom.com
Subject: Re: [REGRESSION] hostapd 2.4..2.7 broken with 4.18+
Message-ID: <20190118221154.ugd3556tycajbijx@e5254000004ec.dyn.armlinux.org.uk>
References: <1547843777-20189-1-git-send-email-arend.vanspriel@broadcom.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1547843777-20189-1-git-send-email-arend.vanspriel@broadcom.com>
User-Agent: NeoMutt/20170113 (1.7.2)
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

On Fri, Jan 18, 2019 at 09:36:17PM +0100, Arend van Spriel wrote:
> On 1/17/2019 11:03 AM, Russell King - ARM Linux admin wrote:> On Wed, Jan 16, 2019 at 02:21:32PM +0100, Arend Van Spriel wrote:
> >> The patch below works for me so can you provide the counters file contents
> >> after hitting the issue.
> > 
> > Okay, with the patch fixed, it seems to have failed last night for some
> > reason... I'm not sure exactly when it died, possibly about an hour
> > after bringing it up.  Here's the full log.
> 
> Sorry for the somewhat late response. I wanted to discuss the log with
> firmware engineer. Can you tell how many stations were connected to this
> AP before and/or when it died? What does "died" mean? From the log I can
> only conclude the firmware is not crashing. So I assume by "died" you
> mean no data is successfully exchanged between hostapd and stations. This
> is probably due to the failing send_key_to_dongle. Could you try the patch
> below to be sure about the key configuration that fails.

By "died" I mean that I've seen several things happen - not always
all of them:

1) the signal perceived by my phone has reduced to a very low level
   (like almost nothing) despite the AP being in direct line of sight
   in the same room, whereas normally it would be showing full signal.

2) the phone (and other devices) will not associate with the AP.
   They go through the initial authentication fine but fail to
   complete the WPA authentication.

Looking at hostapd's debug log, hostapd is aware of the station
attempting to authenticate.  For example, I've observed the following
from hostapd in debug mode:

wlan0: STA xx:xx:xx:xx:xx:xx IEEE 802.11: associated
wlan0: STA xx:xx:xx:xx:xx:xx WPA: event 1 notification
wlan0: STA xx:xx:xx:xx:xx:xx WPA: start authentication
wlan0: STA xx:xx:xx:xx:xx:xx IEEE 802.1X: unauthorizing port
wlan0: STA xx:xx:xx:xx:xx:xx WPA: sending 1/4 msg of 4-Way Handshake
wlan0: STA xx:xx:xx:xx:xx:xx WPA: EAPOL-Key timeout
wlan0: STA xx:xx:xx:xx:xx:xx WPA: sending 1/4 msg of 4-Way Handshake
wlan0: STA xx:xx:xx:xx:xx:xx WPA: EAPOL-Key timeout
wlan0: STA xx:xx:xx:xx:xx:xx WPA: sending 1/4 msg of 4-Way Handshake
wlan0: STA xx:xx:xx:xx:xx:xx WPA: EAPOL-Key timeout
wlan0: STA xx:xx:xx:xx:xx:xx WPA: sending 1/4 msg of 4-Way Handshake
wlan0: STA xx:xx:xx:xx:xx:xx WPA: EAPOL-Key timeout
wlan0: STA xx:xx:xx:xx:xx:xx WPA: PTKSTART: Retry limit 4 reached
wlan0: STA xx:xx:xx:xx:xx:xx WPA: event 3 notification
wlan0: STA xx:xx:xx:xx:xx:xx IEEE 802.1X: unauthorizing port
wlan0: STA xx:xx:xx:xx:xx:xx MLME: MLME-DEAUTHENTICATE.indication(xx:xx:xx:xx:xx:xx
wlan0: STA xx:xx:xx:xx:xx:xx MLME: MLME-DELETEKEYS.request(xx:xx:xx:xx:xx:xx)
wlan0: STA xx:xx:xx:xx:xx:xx IEEE 802.11: disassociated
wlan0: STA xx:xx:xx:xx:xx:xx WPA: event 2 notification
wlan0: STA xx:xx:xx:xx:xx:xx IEEE 802.1X: unauthorizing port

and that repeats.

I picked those out of a strace of hostapd I did on January 11.  Here's
the strace beween the EAPOL stuff:

13663 write(1, "wlan0: STA xx:xx:xx:xx:xx:xx WPA: EAPOL-Key timeout\n", 52) = 52
13663 write(1, "wlan0: STA xx:xx:xx:xx:xx:xx WPA: sending 1/4 msg of 4-Way Handshake\n", 69) = 69
13663 sendto(11, "<removed>", 99, 0, {sa_family=AF_PACKET, proto=0x888e, if14, pkttype=PACKET_HOST, addr(6)={0, 6069441db3a9}, 20) = 99
13663 clock_gettime(CLOCK_BOOTTIME, {244522, 12768606}) = 0
13663 clock_gettime(CLOCK_BOOTTIME, {244522, 13615672}) = 0
13663 _newselect(16, [4 6 8 9 10 12 13 14 15], [], [], {0, 999153}) = 0 (Timeout)
13663 clock_gettime(CLOCK_BOOTTIME, {244523, 16399625}) = 0
13663 write(1, "wlan0: STA xx:xx:xx:xx:xx:xx WPA: EAPOL-Key timeout\n", 52) = 52
13663 write(1, "wlan0: STA xx:xx:xx:xx:xx:xx WPA: sending 1/4 msg of 4-Way Handshake\n", 69) = 69

Hostapd is not getting a response to its 4-way handshake.

I'll try the patch out at some point during the next few days - and
I hope that doesn't result in lots of log spam.

> 
> Regards,
> Arend
> ---
>  drivers/net/wireless/broadcom/brcm80211/brcmfmac/cfg80211.c | 2 ++
>  1 file changed, 2 insertions(+)
> 
> diff --git a/drivers/net/wireless/broadcom/brcm80211/brcmfmac/cfg80211.c b/drivers/net/wireless/broadcom/brcm80211/brcmfmac/cfg80211.c
> index a62c48d..d43d4c0 100644
> --- a/drivers/net/wireless/broadcom/brcm80211/brcmfmac/cfg80211.c
> +++ b/drivers/net/wireless/broadcom/brcm80211/brcmfmac/cfg80211.c
> @@ -460,6 +460,8 @@ static void convert_key_from_CPU(struct brcmf_wsec_key *key,
>  	int err;
>  	struct brcmf_wsec_key_le key_le;
>  
> +	brcmf_err("idx %d algo %d flags %x\n",
> +		  key->index, key->algo, key->flags);
>  	convert_key_from_CPU(key, &key_le);
>  
>  	brcmf_netdev_wait_pend8021x(ifp);
> -- 
> 1.9.1
> 
> 

-- 
RMK's Patch system: https://www.armlinux.org.uk/developer/patches/
FTTC broadband for 0.8mile line in suburbia: sync at 12.1Mbps down 622kbps up
According to speedtest.net: 11.9Mbps down 500kbps up
