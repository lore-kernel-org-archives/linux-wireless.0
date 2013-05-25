Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from wolverine01.qualcomm.com ([199.106.114.254]:22128 "EHLO
	wolverine01.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757056Ab3EYPdC convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sat, 25 May 2013 11:33:02 -0400
From: "Kondratiev, Vladimir" <vkondrat@qti.qualcomm.com>
To: Johannes Berg <johannes@sipsolutions.net>,
	"linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
CC: qca_vkondrat <qca_vkondrat@qca.qualcomm.com>
Subject: RE: [RFC 2/2] cfg80211: separate internal SME implementation
Date: Sat, 25 May 2013 15:33:00 +0000
Message-ID: <A5CA08B46412E243958C77F3825F439519553850@NASANEXD02E.na.qualcomm.com> (sfid-20130525_173321_075884_A1BFCA3B)
References: <1368800743-29877-1-git-send-email-johannes@sipsolutions.net>
	 <1368800743-29877-3-git-send-email-johannes@sipsolutions.net>
	 (sfid-20130517_162600_437051_A11D5D07),<1369433975.13623.19.camel@johannes>
In-Reply-To: <1369433975.13623.19.camel@johannes>
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi Vladimir,

This patch breaks wil6210 compilation. You shouldn't be using the
cfg80211 internal state, even if it's available to drivers for technical
reasons. Please remove the usage of wdev->sme_state from your driver,
I'd like to merge this patch that changes the internal SME
implementation in cfg80211.

johannes

Hi Johannes,

I prepared the patch, need few days to test it and I'll submit.

I have conceptual question regarding wdev private data.
Currently, drivers end up duplicating wdev's data internally. I'd say it is better to track, for example,
SME connection state once. Maybe, it is worth to provide functions to access wdev's data?

Thanks, Vladimir