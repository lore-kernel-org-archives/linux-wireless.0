Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-fx0-f176.google.com ([209.85.220.176]:49069 "EHLO
	mail-fx0-f176.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1761100AbZCOUcX (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sun, 15 Mar 2009 16:32:23 -0400
Received: by fxm24 with SMTP id 24so3260559fxm.37
        for <linux-wireless@vger.kernel.org>; Sun, 15 Mar 2009 13:32:20 -0700 (PDT)
Message-ID: <49BD65D2.1040608@gmail.com> (sfid-20090315_213229_416020_2F9335EE)
Date: Sun, 15 Mar 2009 21:32:18 +0100
From: Jiri Slaby <jirislaby@gmail.com>
MIME-Version: 1.0
To: ath5k-devel@lists.ath5k.org, linux-wireless@vger.kernel.org,
	linville@tuxdriver.com, mcgrof@gmail.com, me@bobcopeland.com,
	nbd@openwrt.org
Subject: Re: [PATCH 2/3] ath5k: Convert chip specific calibration data to
 a generic format
References: <20090315201704.GB5246@makis>
In-Reply-To: <20090315201704.GB5246@makis>
Content-Type: text/plain; charset=us-ascii; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 15.3.2009 21:17, Nick Kossifidis wrote:
> +ath5k_get_pcdac_intercepts(struct ath5k_hw *ah, u8 min, u8 max, u8 *vp)
> +{
> +	const static u16 intercepts3[] =
> +		{ 0, 5, 10, 20, 30, 50, 70, 85, 90, 95, 100 };
> +	const static u16 intercepts3_2[] =
> +		{ 0, 10, 20, 30, 40, 50, 60, 70, 80, 90, 100 };

Just for future, C99 section 6.11.5 says:
Storage-class specifiers
  The placement of a storage-class specifier other than at the
  beginning of the declaration specifiers in a declaration is
  an obsolescent feature.

It means we should use 'static const' instead of 'const static'.

Otherwise it looks good, thanks.
