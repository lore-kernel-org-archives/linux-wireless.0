Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-pa0-f68.google.com ([209.85.220.68]:35703 "EHLO
	mail-pa0-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751673AbcF1CSA (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 27 Jun 2016 22:18:00 -0400
Received: by mail-pa0-f68.google.com with SMTP id hf6so323139pac.2
        for <linux-wireless@vger.kernel.org>; Mon, 27 Jun 2016 19:17:28 -0700 (PDT)
Received: from [10.8.8.54] (static-206-226-73-27.cust.tzulo.com. [206.226.73.27])
        by smtp.gmail.com with ESMTPSA id xs12sm2654390pac.7.2016.06.27.19.17.24
        for <linux-wireless@vger.kernel.org>
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Mon, 27 Jun 2016 19:17:26 -0700 (PDT)
Subject: Possible issue with commit "baa1702290953295e421f0f433e2b1ff4815827c"
References: <878txqevho.fsf@kamboji.qca.qualcomm.com>
To: linux-wireless@vger.kernel.org
From: funkybomber <funkybomber@gmail.com>
Message-ID: <5771DE30.3060407@gmail.com> (sfid-20160628_041806_220663_2F46745E)
Date: Tue, 28 Jun 2016 11:47:20 +0930
MIME-Version: 1.0
In-Reply-To: <878txqevho.fsf@kamboji.qca.qualcomm.com>
Content-Type: text/plain; charset=windows-1252; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hello,

Sorry if this is not the proper way to report this but I noticed 
something that has to be an error in commit 
"baa1702290953295e421f0f433e2b1ff4815827c"

https://git.kernel.org/cgit/linux/kernel/git/torvalds/linux.git/commit/?id=baa1702290953295e421f0f433e2b1ff4815827c 



in the file "halbtcoutsrc.c"

there is:

+ if ((gl_bt_coexist.board_info.pg_ant_num == 2) &&
+     (gl_bt_coexist.board_info.btdm_ant_num == 1))
+         gl_bt_coexist.board_info.btdm_ant_pos =
+                         BTC_ANTENNA_AT_MAIN_PORT;
+ else
+         gl_bt_coexist.board_info.btdm_ant_pos =
+                         BTC_ANTENNA_AT_MAIN_PORT;


The action performed under the IF condition is the same as the one under 
the ELSE condition, so either there is a bug here or there simply is no 
need for the IF/ELSE clause.

Sorry if I'm all wrong on this, I was just casually looking through code 
and this striked weird to me!

Take care!
