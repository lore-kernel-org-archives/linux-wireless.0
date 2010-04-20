Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.atheros.com ([12.36.123.2]:12294 "EHLO mail.atheros.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753409Ab0DTEcb (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Tue, 20 Apr 2010 00:32:31 -0400
Received: from mail.atheros.com ([10.10.20.108])
	by sidewinder.atheros.com
	for <linux-wireless@vger.kernel.org>; Mon, 19 Apr 2010 21:32:31 -0700
From: Sujith <Sujith.Manoharan@atheros.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Message-ID: <19405.11838.119234.371361@gargle.gargle.HOWL>
Date: Tue, 20 Apr 2010 10:01:58 +0530
To: "tom.leiming@gmail.com" <tom.leiming@gmail.com>
CC: Luis Rodriguez <Luis.Rodriguez@Atheros.com>,
	"linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
	"linville@tuxdriver.com" <linville@tuxdriver.com>
Subject: [PATCH] ath9k-htc: speedup disconnect handling
In-Reply-To: <1271691883-13133-1-git-send-email-tom.leiming@gmail.com>
References: <1271691883-13133-1-git-send-email-tom.leiming@gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

tom.leiming@gmail.com wrote:
> This patch detects the disconnect in wmi register write path,
> then speedup the disconnect handling.

What bug does this fix ? Submission of URBs in the REGOUT pipe
should not really fail, and if it does, it is indicative of a deeper
problem and recovery mechanisms are needed.

If you do get WMI failures, can you post the relevant sections
from the kernel log ?

Sujith
