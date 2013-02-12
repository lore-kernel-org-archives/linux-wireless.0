Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from he.sipsolutions.net ([78.46.109.217]:46466 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932131Ab3BLJEA (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 12 Feb 2013 04:04:00 -0500
Message-ID: <1360659833.8178.0.camel@jlt4.sipsolutions.net> (sfid-20130212_100408_459358_07B619F4)
Subject: Re: [PATCH] nl80211: minor correction in sample wowlan mask
 calculation
From: Johannes Berg <johannes@sipsolutions.net>
To: Bing Zhao <bzhao@marvell.com>
Cc: linux-wireless@vger.kernel.org,
	Amitkumar Karwar <akarwar@marvell.com>
Date: Tue, 12 Feb 2013 10:03:53 +0100
In-Reply-To: <1360655802-21515-1-git-send-email-bzhao@marvell.com>
References: <1360655802-21515-1-git-send-email-bzhao@marvell.com>
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Mon, 2013-02-11 at 23:56 -0800, Bing Zhao wrote:
> From: Amitkumar Karwar <akarwar@marvell.com>
> 
> The match 00:xx:00:00:xx:00:00:00:00:xx:xx:xx (where xx indicates
> "don't care") should be represented by a pattern of twelve zero
> bytes, and a mask of "0xed,0x01", not "0xed,0x07".
> 
> mask_len = (pat_len + 7) / 8 = (12 + 7) / 8 = 2
> Hence the mask will be of 2 bytes.
> Replace each valid byte in pattern by 1 and don't care byte by 0:
> 10110111 1000 (0000)
> 
> 1st byte of pattern corresponds to lower order bit in first byte
> of mask. And 9th byte of pattern corresponds to lower order bit
> in second byte of mask. With this logic the mask will be
> 11101101 00000001 = 0xed 0x01

Yep, clearly I got that wrong, thanks! Applied.

johannes

