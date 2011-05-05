Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mout6.freenet.de ([195.4.92.96]:59699 "EHLO mout6.freenet.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751028Ab1EEPsX (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Thu, 5 May 2011 11:48:23 -0400
Received: from [195.4.92.27] (helo=17.mx.freenet.de)
	by mout6.freenet.de with esmtpa (ID andihartmann@freenet.de) (port 25) (Exim 4.72 #5)
	id 1QI0mr-0002cK-3W
	for linux-wireless@vger.kernel.org; Thu, 05 May 2011 17:48:21 +0200
Received: from p54a1867a.dip0.t-ipconnect.de ([84.161.134.122]:59801 helo=mail.maya.org)
	by 17.mx.freenet.de with esmtpsa (ID andihartmann@freenet.de) (TLSv1:AES256-SHA:256) (port 25) (Exim 4.72 #3)
	id 1QI0mq-00076o-SD
	for linux-wireless@vger.kernel.org; Thu, 05 May 2011 17:48:21 +0200
Received: from [192.168.1.6] (dualc.maya.org [192.168.1.6])
	by mail.maya.org (8.14.4/8.13.8) with ESMTP id p45FmHxS002872
	for <linux-wireless@vger.kernel.org>; Thu, 5 May 2011 17:48:18 +0200
Message-ID: <4DC2C743.9060004@01019freenet.de> (sfid-20110505_174826_627427_BAF6AEBE)
Date: Thu, 05 May 2011 17:50:27 +0200
From: Andreas Hartmann <andihartmann@01019freenet.de>
MIME-Version: 1.0
To: linux-wireless@vger.kernel.org
Subject: =?windows-1252?Q?compile-error_agg-tx=2Ec=3A_error=3A_impl?=
 =?windows-1252?Q?icit_declaration_of_function_=91kfree=5Frcu=92?=
Content-Type: text/plain; charset=windows-1252
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hello,

since May, there is a compile error in compat-wireless (against kernel
2.6.34):


compat-wireless-2011-05-04-p/net/mac80211/agg-tx.c: In function
‘___ieee80211_stop_tx_ba_session’:
compat-wireless-2011-05-04-p/net/mac80211/agg-tx.c:158: error: implicit
declaration of function ‘kfree_rcu’
compat-wireless-2011-05-04-p/net/mac80211/agg-tx.c:158: error:
‘rcu_head’ undeclared (first use in this function)
compat-wireless-2011-05-04-p/net/mac80211/agg-tx.c:158: error: (Each
undeclared identifier is reported only once
compat-wireless-2011-05-04-p/net/mac80211/agg-tx.c:158: error: for each
function it appears in.)
compat-wireless-2011-05-04-p/net/mac80211/agg-tx.c: In function
‘ieee80211_tx_ba_session_handle_start’:
compat-wireless-2011-05-04-p/net/mac80211/agg-tx.c:317: error:
‘rcu_head’ undeclared (first use in this function)
compat-wireless-2011-05-04-p/net/mac80211/agg-tx.c: In function
‘ieee80211_stop_tx_ba_cb’:
compat-wireless-2011-05-04-p/net/mac80211/agg-tx.c:696: error:
‘rcu_head’ undeclared (first use in this function)


See https://patchwork.kernel.org/patch/745352/


Regards,
Andreas
