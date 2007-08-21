Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from nf-out-0910.google.com ([64.233.182.187]:3172 "EHLO
	nf-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753207AbXHUVAa (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 21 Aug 2007 17:00:30 -0400
Received: by nf-out-0910.google.com with SMTP id g13so974434nfb
        for <linux-wireless@vger.kernel.org>; Tue, 21 Aug 2007 14:00:29 -0700 (PDT)
To: Johannes Berg <johannes@sipsolutions.net>
Subject: Re: [RFC 1/2] mac80211: allow drivers to indicate failed FCS/PLCP checksum
Date: Tue, 21 Aug 2007 23:07:59 +0200
Cc: linux-wireless@vger.kernel.org
References: <20070821161845.165557000@sipsolutions.net> <20070821161942.159647000@sipsolutions.net>
In-Reply-To: <20070821161942.159647000@sipsolutions.net>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-15"
Message-Id: <200708212307.59926.IvDoorn@gmail.com>
From: Ivo van Doorn <ivdoorn@gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Tuesday 21 August 2007, Johannes Berg wrote:
> This patch allows drivers to indicate bad FCS/PLCP CRC to the stack and
> have the stack drop packets like that except for monitor interfaces.
> 
> Signed-off-by: Johannes Berg <johannes@sipsolutions.net>
> ---
> Changes since v1:
>  * filter bad frames early in the RX code and don't count
>    them nor try to get a STA for them
> 
>  include/net/mac80211.h |    2 ++
>  net/mac80211/rx.c      |   31 ++++++++++++++++++++++++++++---
>  2 files changed, 30 insertions(+), 3 deletions(-)
> 
> --- wireless-dev.orig/include/net/mac80211.h	2007-08-21 16:26:46.405923881 +0200
> +++ wireless-dev/include/net/mac80211.h	2007-08-21 16:28:19.015923881 +0200
> @@ -243,6 +243,8 @@ struct ieee80211_rx_status {
>  #define RX_FLAG_MMIC_ERROR	(1<<0)
>  #define RX_FLAG_DECRYPTED	(1<<1)
>  #define RX_FLAG_RADIOTAP	(1<<2)
> +#define RX_FLAG_FAILED_FCS_CRC	(1<<3)
> +#define RX_FLAG_FAILED_PLCP_CRC	(1<<4)
>  	int flag;
>  };

Do we need another flag to indicate ICV errors?
rt2x00 has the following fields to indicate problems during hardware decryption:
	ICV error -> How to report this to mac80211?
	MIC error -> The RX_FLAG_MMIC_ERROR flag can be set
	invalid key -> Could best be done by just not setting RX_FLAG_DECRYPTED I assume.

Ivo
