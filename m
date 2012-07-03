Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from he.sipsolutions.net ([78.46.109.217]:37855 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751668Ab2GCLzY (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 3 Jul 2012 07:55:24 -0400
Message-ID: <1341316520.20124.0.camel@jlt3.sipsolutions.net> (sfid-20120703_135528_298009_C53EC6AD)
Subject: Re: [PATCH 0/2] High bitrate support
From: Johannes Berg <johannes@sipsolutions.net>
To: Vladimir Kondratiev <qca_vkondrat@qca.qualcomm.com>
Cc: "John W . Linville" <linville@tuxdriver.com>,
	linux-wireless@vger.kernel.org,
	"Luis R . Rodriguez" <rodrigue@qca.qualcomm.com>
Date: Tue, 03 Jul 2012 13:55:20 +0200
In-Reply-To: <1341304650-2593-1-git-send-email-qca_vkondrat@qca.qualcomm.com>
References: <1341304650-2593-1-git-send-email-qca_vkondrat@qca.qualcomm.com>
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Tue, 2012-07-03 at 11:37 +0300, Vladimir Kondratiev wrote:
> Proposed patches solve issue with high bitrates not fitting into u16.                                                                                                              
>                                                                                                                                                                                    
> I split it into 2 patches: one introduces new u32 bitrate,                                                                                                                         
> and 2-nd adds 60g specific calculations.                                                                                                                                           
>                                                                                                                                                                                    
> Idea is to report (in nl80211) both old and new values,
> or only new if it not fits into u16.
> User space tools will migrate to the new bitrate, then old one
> may be removed from kernel.
> 
> There are few places where cfg80211_calculate_bitrate() used
> besides nl80211.c; but these places are OK with bitrate changing
> from u16 to u32.
> 
> Vladimir Kondratiev (2):
>   {nl,cfg}80211: support high bitrates
>   cfg80211: bitrate calculation for 60g

I've applied this (but not yet pushed out in case somebody objects
still).

I've fixed it for you, but please break your commit logs at (at most) 72
characters.

johannes

