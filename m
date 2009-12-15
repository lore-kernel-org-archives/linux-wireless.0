Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-ew0-f219.google.com ([209.85.219.219]:36815 "EHLO
	mail-ew0-f219.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1760553AbZLORJd (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 15 Dec 2009 12:09:33 -0500
Received: by mail-ew0-f219.google.com with SMTP id 19so71271ewy.21
        for <linux-wireless@vger.kernel.org>; Tue, 15 Dec 2009 09:09:32 -0800 (PST)
From: Ivo van Doorn <ivdoorn@gmail.com>
To: Gertjan van Wingerde <gwingerde@gmail.com>
Subject: Re: [PATCH v2.6.33] rt2x00: Fix calculation of rt2800 iveiv entry offset.
Date: Tue, 15 Dec 2009 18:09:31 +0100
Cc: linville@tuxdriver.com, users@rt2x00.serialmonkey.com,
	linux-wireless@vger.kernel.org
References: <1260829951-27139-1-git-send-email-gwingerde@gmail.com>
In-Reply-To: <1260829951-27139-1-git-send-email-gwingerde@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-15"
Message-Id: <200912151809.31376.IvDoorn@gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Monday 14 December 2009, Gertjan van Wingerde wrote:
> Fix typo. The index should be multiplied by the entry size, not 'and'-ed.
> 
> Found via code-inspection.
> 
> Signed-off-by: Gertjan van Wingerde <gwingerde@gmail.com>

Acked-by: Ivo van Doorn <IvDoorn@gmail.com>

> ---
>  drivers/net/wireless/rt2x00/rt2800.h |    2 +-
>  1 files changed, 1 insertions(+), 1 deletions(-)
> 
> diff --git a/drivers/net/wireless/rt2x00/rt2800.h b/drivers/net/wireless/rt2x00/rt2800.h
> index c5fe867..1a7eae3 100644
> --- a/drivers/net/wireless/rt2x00/rt2800.h
> +++ b/drivers/net/wireless/rt2x00/rt2800.h
> @@ -1323,7 +1323,7 @@
>  #define PAIRWISE_KEY_ENTRY(__idx) \
>  	( PAIRWISE_KEY_TABLE_BASE + ((__idx) * sizeof(struct hw_key_entry)) )
>  #define MAC_IVEIV_ENTRY(__idx) \
> -	( MAC_IVEIV_TABLE_BASE + ((__idx) & sizeof(struct mac_iveiv_entry)) )
> +	( MAC_IVEIV_TABLE_BASE + ((__idx) * sizeof(struct mac_iveiv_entry)) )
>  #define MAC_WCID_ATTR_ENTRY(__idx) \
>  	( MAC_WCID_ATTRIBUTE_BASE + ((__idx) * sizeof(u32)) )
>  #define SHARED_KEY_ENTRY(__idx) \


