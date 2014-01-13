Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail3-relais-sop.national.inria.fr ([192.134.164.104]:52642
	"EHLO mail3-relais-sop.national.inria.fr" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751928AbaAMPVq (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 13 Jan 2014 10:21:46 -0500
From: Julia Lawall <Julia.Lawall@lip6.fr>
To: brcm80211-dev-list@broadcom.com
Cc: kernel-janitors@vger.kernel.org, linux-wireless@vger.kernel.org,
	netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
	linux-fbdev@vger.kernel.org, devel@driverdev.osuosl.org
Subject: [PATCH 0/4] delete useless variable
Date: Mon, 13 Jan 2014 17:17:23 +0100
Message-Id: <1389629847-5330-1-git-send-email-Julia.Lawall@lip6.fr> (sfid-20140113_162230_435526_BD5FF3AB)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

These patches delete declarations and initializations of variables that are
only assigned to constants but never used otherwise.

The complete semantic patch that makes this change is as follows:
(http://coccinelle.lip6.fr/)

// <smpl>
@r exists@
type T;
identifier i,i2;
position p;
@@

T i@p;
... 
i = i2

@@
type r.T;
identifier r.i;
constant c;
position p != r.p;
@@

-T i@p;
<... when != i
-i = c;
...>
// </smpl>

