Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from s3.sipsolutions.net ([144.76.43.152]:41043 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756592Ab3EXWTj (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 24 May 2013 18:19:39 -0400
Message-ID: <1369433975.13623.19.camel@johannes> (sfid-20130525_001945_330653_AFA9486C)
Subject: Re: [RFC 2/2] cfg80211: separate internal SME implementation
From: Johannes Berg <johannes@sipsolutions.net>
To: linux-wireless@vger.kernel.org
Cc: Vladimir Kondratiev <qca_vkondrat@qca.qualcomm.com>
Date: Sat, 25 May 2013 00:19:35 +0200
In-Reply-To: <1368800743-29877-3-git-send-email-johannes@sipsolutions.net> (sfid-20130517_162600_437051_A11D5D07)
References: <1368800743-29877-1-git-send-email-johannes@sipsolutions.net>
	 <1368800743-29877-3-git-send-email-johannes@sipsolutions.net>
	 (sfid-20130517_162600_437051_A11D5D07)
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi Vladimir,

This patch breaks wil6210 compilation. You shouldn't be using the
cfg80211 internal state, even if it's available to drivers for technical
reasons. Please remove the usage of wdev->sme_state from your driver,
I'd like to merge this patch that changes the internal SME
implementation in cfg80211.

johannes

