Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from the.earth.li ([217.147.81.2]:38844 "EHLO the.earth.li"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751210AbYJaULb (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Fri, 31 Oct 2008 16:11:31 -0400
Received: from noodles by the.earth.li with local (Exim 4.63)
	(envelope-from <noodles@earth.li>)
	id 1Kvzox-0007rk-P6
	for linux-wireless@vger.kernel.org; Fri, 31 Oct 2008 19:38:11 +0000
Date: Thu, 30 Oct 2008 22:46:48 +0000
From: Jonathan McDowell <noodles@earth.li>
To: linux-wireless@kernel.org
Cc: Ivo van Doorn <IvDoorn@gmail.com>,
	"John W. Linville" <linville@tuxdriver.com>,
	Henrique de Moraes Holschuh <hmh@hmh.eng.br>
Subject: [PATCH] Fix logic error in rfkill_check_duplicity
Message-ID: <20081030224648.GL3162@earth.li> (sfid-20081031_211137_043134_E229AFDD)
References: <20081029164006.GH3162@earth.li> <1225309212.3068.44.camel@achroite> <20081030102746.GI3162@earth.li>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <20081030102746.GI3162@earth.li>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

(already sent to lkml & netdev, resending here with Henrique's Ack as
per his followup there)

On Thu, Oct 30, 2008 at 10:27:46AM +0000, Jonathan McDowell wrote:
 
> I'll have a prod at why the [hso] rfkill stuff isn't working next

Ok, I believe this is due to the addition of rfkill_check_duplicity in
rfkill and the fact that test_bit actually returns a negative value
rather than the postive one expected (which is of course equally true).
So when the second WLAN device (the hso device, with the EEE PC WLAN
being the first) comes along rfkill_check_duplicity returns a negative
value and so rfkill_register returns an error. Patch below fixes this
for me.

Signed-Off-By: Jonathan McDowell <noodles@earth.li>
Acked-by: Henrique de Moraes Holschuh <hmh@hmh.eng.br>

-----
diff --git a/net/rfkill/rfkill.c b/net/rfkill/rfkill.c
index f949a48..1ba35a7 100644
--- a/net/rfkill/rfkill.c
+++ b/net/rfkill/rfkill.c
@@ -603,7 +603,7 @@ static int rfkill_check_duplicity(const struct rfkill *rfkil
        }
 
        /* 0: first switch of its kind */
-       return test_bit(rfkill->type, seen);
+       return (test_bit(rfkill->type, seen)) ? 1 : 0;
 }
 
 static int rfkill_add_switch(struct rfkill *rfkill)
-----

J.

-- 
/-\                             |  Shall I call the United Nations?
|@/  Debian GNU/Linux Developer |
\-                              |
