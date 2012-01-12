Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtp1.u-psud.fr ([129.175.33.41]:53161 "EHLO smtp1.u-psud.fr"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751153Ab2ALKKG (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Thu, 12 Jan 2012 05:10:06 -0500
Message-ID: <4F0EB16B.8070606@lri.fr> (sfid-20120112_111011_335488_166AD32D)
Date: Thu, 12 Jan 2012 11:09:47 +0100
From: Nicolas Cavallari <Nicolas.Cavallari@lri.fr>
MIME-Version: 1.0
To: Christian Lamparter <chunkeey@googlemail.com>
CC: Nicolas Cavallari <Nicolas.Cavallari@lri.fr>,
	"John W. Linville" <linville@tuxdriver.com>,
	linux-wireless@vger.kernel.org
Subject: Re: [PATCH] carl9170: claim to support IBSS RSN.
References: <1326296690-2644-1-git-send-email-cavallar@lri.fr> <201201111713.36373.chunkeey@googlemail.com>
In-Reply-To: <201201111713.36373.chunkeey@googlemail.com>
Content-Type: text/plain; charset=ISO-8859-15
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 11/01/2012 17:13, Christian Lamparter wrote:
> On Wednesday, January 11, 2012 04:44:50 PM Nicolas Cavallari wrote:
>> On carl9170, HW encryption is disabled on IBSS; the mac80211
>> software-based encryption is used instead. As mac80211 supports IBSS
>> RSN (per-STA GTK), claim its support in the carl9170 PHY.
> 
> Uh, was IBSS RSN fixed? Sure, if it works, why not. 
> 

Fixed or not, it works for me and anyway there is this code in
ieee80211_alloc_hw() :

207aba60 573)   if (!ops->set_key)
207aba60 574)           wiphy->flags |= WIPHY_FLAG_IBSS_RSN;

Which enables IBSS RSN on all SW-crypto-only devices.
