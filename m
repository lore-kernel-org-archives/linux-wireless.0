Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-fx0-f168.google.com ([209.85.220.168]:57732 "EHLO
	mail-fx0-f168.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751115AbZEYLOQ (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 25 May 2009 07:14:16 -0400
Received: by fxm12 with SMTP id 12so1251971fxm.37
        for <linux-wireless@vger.kernel.org>; Mon, 25 May 2009 04:14:16 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <3ace41890905250008q255d15dej45a4f53d9f8c90e4@mail.gmail.com>
References: <43e72e890904032115m7548f967m5020481c660c8f13@mail.gmail.com>
	 <3ace41890904041944p6cd60084ub2d05a85373459c3@mail.gmail.com>
	 <3ace41890904062120o78018361x409bb3e20b735b75@mail.gmail.com>
	 <43e72e890904062234m3d572f36t1aa7fefa5f78ae74@mail.gmail.com>
	 <3ace41890904070049tc2ed1baod4399a327505ef09@mail.gmail.com>
	 <20090407160812.GA5758@tesla>
	 <3ace41890905250008q255d15dej45a4f53d9f8c90e4@mail.gmail.com>
Date: Mon, 25 May 2009 12:14:15 +0100
Message-ID: <3ace41890905250414n37798736yc0a5090a67206129@mail.gmail.com>
Subject: Re: zd1211 3.0.0.56 "vendor driver" - please help port to zd1211rw
From: Hin-Tak Leung <hintak.leung@gmail.com>
To: "Luis R. Rodriguez" <lrodriguez@atheros.com>
Cc: linux-wireless <linux-wireless@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Mon, May 25, 2009 at 8:08 AM, Hin-Tak Leung <hintak.leung@gmail.com> wrote:
For 32-bit, it seems to work alright, except for one oop
> in AP mode when a client connects so far (out of a few connects).

I think I found the reason of oops - it is a regression newly
introduced in 3.0.0.56, actually...
Diff below, which probably has some white space problems from
cut-and-paste, but should be obvious...

------------------------------------------------------
>From 7a12176808ba628b80aeadc44bc27a042735387a Mon Sep 17 00:00:00 2001
From: Hin-Tak Leung <HinTak.Leung@gmail.com>
Date: Mon, 25 May 2009 11:43:32 +0100
Subject: [PATCH] fix NULL pointer deference in newly-introduced in 3.0.0.56

Tchal_WaitChalRsp()  AsocTimeOut() can be called with arg=NULL
from zd_SendTChalMsg() and zd_SendTAsocMsg() respectively. New to 3.0.0.56
is code to clear frame description, which does not check for NULL input.
Tchal_WaitChalRsp() oops is observed in AP mode when a client tries to connect.
---
 ar2524drv/src/zdasocsvc.c |    3 +++
 ar2524drv/src/zdauthrsp.c |    3 +++
 2 files changed, 6 insertions(+), 0 deletions(-)

diff --git a/ar2524drv/src/zdasocsvc.c b/ar2524drv/src/zdasocsvc.c
index 90bba79..780a950 100644
--- a/ar2524drv/src/zdasocsvc.c
+++ b/ar2524drv/src/zdasocsvc.c
@@ -659,6 +659,8 @@ BOOLEAN AsocTimeOut(Signal_t *signal)
 	}
 	
 	mRequestFlag |= CONNECT_TOUT_SET;
+  if(signal != NULL)
+  {
     if(signal->frmInfo.frmDesc != NULL)
     {
         freeFdesc(signal->frmInfo.frmDesc);
@@ -666,6 +668,7 @@ BOOLEAN AsocTimeOut(Signal_t *signal)
     }
     pdot11Obj->ReleaseBuffer(signal->buf);
     freeSignal(signal);
+  }
 	return FALSE;
 }

diff --git a/ar2524drv/src/zdauthrsp.c b/ar2524drv/src/zdauthrsp.c
index 081b9bb..27c2bb9 100644
--- a/ar2524drv/src/zdauthrsp.c
+++ b/ar2524drv/src/zdauthrsp.c
@@ -198,6 +198,8 @@ BOOLEAN Tchal_WaitChalRsp(Signal_t *signal)
 		UpdateStaStatus(&Sta, STATION_STATE_NOT_AUTH, vapId);
 		AuthRspState = STE_AUTH_RSP_IDLE;
 	}
+  if(signal != NULL)
+  {
     if(signal->frmInfo.frmDesc != NULL)
     {
         freeFdesc(signal->frmInfo.frmDesc);
@@ -205,6 +207,7 @@ BOOLEAN Tchal_WaitChalRsp(Signal_t *signal)
     }
     pdot11Obj->ReleaseBuffer(signal->buf);
     freeSignal(signal);
+  }
 	return FALSE;
 }

-- 
1.6.0.6

---------------------------------------------------------
