Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.tpi.com ([198.107.51.143]:4311 "EHLO mail.tpi.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754883AbYJ2TTu (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Wed, 29 Oct 2008 15:19:50 -0400
Message-ID: <4908B754.1050400@tpi.com> (sfid-20081029_202012_616694_C242082B)
Date: Wed, 29 Oct 2008 13:19:48 -0600
From: Tim Gardner <tcanonical@tpi.com>
Reply-To: tim.gardner@canonical.com
MIME-Version: 1.0
To: mick@madwifi.org
CC: linux-wireless@vger.kernel.org
Subject: wireless-testing commit eb9d4e8399181357cb6f6625ba7f849987432c6c
 causes stalls
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

This commit 'ath5k: Update interrupt masking code' causes stalls under
load when built using compat-wireless on 2.6.27. There is no output from
dmesg, but it occasionally recovers and moves a few more packets before
stalling again. Luis suggested reverting
eb9d4e8399181357cb6f6625ba7f849987432c6c which I did. Now it appears to
work normally.

I also think this patch should be broken into multiple pieces. There
appear to be at least 3 functional changes addressed in this single patch.

rtg
-- 
Tim Gardner tim.gardner@canonical.com
