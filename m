Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-wy0-f174.google.com ([74.125.82.174]:53278 "EHLO
	mail-wy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754372Ab1JJOfM convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 10 Oct 2011 10:35:12 -0400
Received: by wyg34 with SMTP id 34so5951719wyg.19
        for <linux-wireless@vger.kernel.org>; Mon, 10 Oct 2011 07:35:11 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <1317335676-3424-22-git-send-email-frankyl@broadcom.com>
References: <1317145530-18839-1-git-send-email-frankyl@broadcom.com>
	<1317335676-3424-1-git-send-email-frankyl@broadcom.com>
	<1317335676-3424-22-git-send-email-frankyl@broadcom.com>
Date: Mon, 10 Oct 2011 16:35:11 +0200
Message-ID: <CACna6rw3N5XJwiFVAWEHBNjANVCd5cXCaweCm_dVdcLUdu-BMQ@mail.gmail.com> (sfid-20111010_163524_797431_A30B4BD5)
Subject: Re: [PATCH v3 21/25] staging: brcm80211: use endian annotated
 structures in brcmsmac
From: =?UTF-8?B?UmFmYcWCIE1pxYJlY2tp?= <zajec5@gmail.com>
To: Franky Lin <frankyl@broadcom.com>
Cc: gregkh@suse.de, devel@linuxdriverproject.org,
	linux-wireless@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

2011/9/30 Franky Lin <frankyl@broadcom.com>:
> From: Arend van Spriel <arend@broadcom.com>


> +struct d11rxhdr_le {
> +       __le16 RxFrameSize;
> +       u16 PAD;
> +       __le16 PhyRxStatus_0;
> +       __le16 PhyRxStatus_1;
> +       __le16 PhyRxStatus_2;
> +       __le16 PhyRxStatus_3;
> +       __le16 PhyRxStatus_4;
> +       __le16 PhyRxStatus_5;
> +       __le16 RxStatus1;
> +       __le16 RxStatus2;
> +       __le16 RxTSFTime;
> +       __le16 RxChan;
> +} __packed;

So you decided to use __packed here anyway for some reason? ;)


>  struct d11rxhdr {
>        u16 RxFrameSize;
>        u16 PAD;
> @@ -1392,20 +1407,18 @@ struct d11rxhdr {
>        u16 RxStatus2;
>        u16 RxTSFTime;
>        u16 RxChan;
> -} __packed;
> +};

You should be right, none compiler should break that alignment...
still no idea why usage of __packed hurt anyone, made code clear
according to me.

-- 
Rafał
