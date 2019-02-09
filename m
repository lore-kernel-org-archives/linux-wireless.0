Return-Path: <SRS0=Ta2d=QQ=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.8 required=3.0 tests=DKIM_INVALID,DKIM_SIGNED,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,MENTIONS_GIT_HOSTING,
	SPF_PASS,URIBL_BLOCKED autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B3961C282C4
	for <linux-wireless@archiver.kernel.org>; Sat,  9 Feb 2019 08:31:25 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 7D67F21773
	for <linux-wireless@archiver.kernel.org>; Sat,  9 Feb 2019 08:31:25 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="key not found in DNS" (0-bit key) header.d=codeaurora.org header.i=@codeaurora.org header.b="jJx321Kq";
	dkim=fail reason="key not found in DNS" (0-bit key) header.d=codeaurora.org header.i=@codeaurora.org header.b="Bkjf3F/t"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726788AbfBIIbY (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Sat, 9 Feb 2019 03:31:24 -0500
Received: from smtp.codeaurora.org ([198.145.29.96]:33008 "EHLO
        smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726047AbfBIIbY (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Sat, 9 Feb 2019 03:31:24 -0500
Received: by smtp.codeaurora.org (Postfix, from userid 1000)
        id 6DB96607DD; Sat,  9 Feb 2019 08:31:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=codeaurora.org;
        s=default; t=1549701083;
        bh=1CkMdSb3tN4kl4UfHP6K1AhkwlD5/dFr5c76rSNbHSc=;
        h=From:To:Cc:Subject:References:Date:In-Reply-To:From;
        b=jJx321Kq9dTYLo/cWl2dCqfAgzf2GQF/nHuw7ektaNWaCcIA4o4VgSbaeA+lMHtzJ
         HoA6GmmgiQS/5fFlrpuH7vN7Mc5c6Bt+JPJwAWUbOA1bI09zeAczC8xr16Ll0JjS4f
         yQSNblaOt14FYBnmzPrTeBnQjAzh57FBPKWififM=
Received: from potku.adurom.net (88-114-240-156.elisa-laajakaista.fi [88.114.240.156])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        (Authenticated sender: kvalo@smtp.codeaurora.org)
        by smtp.codeaurora.org (Postfix) with ESMTPSA id 1ACD2602CB;
        Sat,  9 Feb 2019 08:31:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=codeaurora.org;
        s=default; t=1549701082;
        bh=1CkMdSb3tN4kl4UfHP6K1AhkwlD5/dFr5c76rSNbHSc=;
        h=From:To:Cc:Subject:References:Date:In-Reply-To:From;
        b=Bkjf3F/true7dBZIj5pPGZ/mx1hVYWkGW9SsZQf7ZCV8XE4rAN5wKaI84gUl3oIOt
         BWHMDR8FgAMXY/vdzVutpi0KcCeO7SkW9JThVHZDGuj2+5wqIiU+duPScgqhckWYol
         I8lerwehu5+0p0rCLScf/Wn/X0ZSJ678y69aTMOc=
DMARC-Filter: OpenDMARC Filter v1.3.2 smtp.codeaurora.org 1ACD2602CB
Authentication-Results: pdx-caf-mail.web.codeaurora.org; dmarc=none (p=none dis=none) header.from=codeaurora.org
Authentication-Results: pdx-caf-mail.web.codeaurora.org; spf=none smtp.mailfrom=kvalo@codeaurora.org
From:   Kalle Valo <kvalo@codeaurora.org>
To:     kbuild test robot <lkp@intel.com>
Cc:     Maya Erez <merez@codeaurora.org>, kbuild-all@01.org,
        ath10k@lists.infradead.org, linux-wireless@vger.kernel.org
Subject: Re: [ath6kl:pending 12/32] drivers/net/wireless/ath/wil6210/txrx.c:341:25: warning: 'rtap' may be used uninitialized in this function
References: <201902090225.xWQGRZWS%fengguang.wu@intel.com>
Date:   Sat, 09 Feb 2019 10:31:18 +0200
In-Reply-To: <201902090225.xWQGRZWS%fengguang.wu@intel.com> (kbuild test
        robot's message of "Sat, 9 Feb 2019 02:26:28 +0800")
Message-ID: <87pns17489.fsf@kamboji.qca.qualcomm.com>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/24.5 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

+ linux-wireless

kbuild test robot <lkp@intel.com> writes:

> tree:   https://git.kernel.org/pub/scm/linux/kernel/git/kvalo/ath.git pending
> head:   6e56895b48f885973e44231cac5f3f39a7068d36
> commit: 18c7c63dcc54feb0e0438ff20b528ea3945d82e0 [12/32] wil6210: remove rtap_include_phy_info module param
> config: xtensa-allyesconfig (attached as .config)
> compiler: xtensa-linux-gcc (GCC) 8.2.0
> reproduce:
>         wget https://raw.githubusercontent.com/intel/lkp-tests/master/sbin/make.cross -O ~/bin/make.cross
>         chmod +x ~/bin/make.cross
>         git checkout 18c7c63dcc54feb0e0438ff20b528ea3945d82e0
>         # save the attached .config to linux build tree
>         GCC_VERSION=8.2.0 make.cross ARCH=xtensa 
>
> Note: it may well be a FALSE warning. FWIW you are at least aware of it now.
> http://gcc.gnu.org/wiki/Better_Uninitialized_Warnings
>
> All warnings (new ones prefixed by >>):
>
>    drivers/net/wireless/ath/wil6210/txrx.c: In function 'wil_vring_reap_rx':
>>> drivers/net/wireless/ath/wil6210/txrx.c:341:25: warning: 'rtap' may be used uninitialized in this function [-Wmaybe-uninitialized]
>      rtap->rthdr.it_version = PKTHDR_RADIOTAP_VERSION;
>    drivers/net/wireless/ath/wil6210/txrx.c:331:23: note: 'rtap' was declared here
>      struct wil6210_rtap *rtap;
>                           ^~~~
>
> vim +/rtap +341 drivers/net/wireless/ath/wil6210/txrx.c
>
>    304	
>    305	/**
>    306	 * Adds radiotap header
>    307	 *
>    308	 * Any error indicated as "Bad FCS"
>    309	 *
>    310	 * Vendor data for 04:ce:14-1 (Wilocity-1) consists of:
>    311	 *  - Rx descriptor: 32 bytes
>    312	 *  - Phy info
>    313	 */
>    314	static void wil_rx_add_radiotap_header(struct wil6210_priv *wil,
>    315					       struct sk_buff *skb)
>    316	{
>    317		struct wil6210_rtap {
>    318			struct ieee80211_radiotap_header rthdr;
>    319			/* fields should be in the order of bits in rthdr.it_present */
>    320			/* flags */
>    321			u8 flags;
>    322			/* channel */
>    323			__le16 chnl_freq __aligned(2);
>    324			__le16 chnl_flags;
>    325			/* MCS */
>    326			u8 mcs_present;
>    327			u8 mcs_flags;
>    328			u8 mcs_index;
>    329		} __packed;

This is an odd place to define a structure.

>    330		struct vring_rx_desc *d = wil_skb_rxdesc(skb);
>    331		struct wil6210_rtap *rtap;
>    332		int rtap_len = sizeof(struct wil6210_rtap);
>    333		struct ieee80211_channel *ch = wil->monitor_chandef.chan;
>    334	
>    335		if (skb_headroom(skb) < rtap_len &&
>    336		    pskb_expand_head(skb, rtap_len, 0, GFP_ATOMIC)) {
>    337			wil_err(wil, "Unable to expand headroom to %d\n", rtap_len);
>    338			return;
>    339		}
>    340	
>  > 341		rtap->rthdr.it_version = PKTHDR_RADIOTAP_VERSION;

Looks like a valid warning to me.

-- 
Kalle Valo
