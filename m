Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from blaine.gmane.org ([80.91.229.8]:50460 "EHLO hugh.gmane.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752611AbYFVTlt (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Sun, 22 Jun 2008 15:41:49 -0400
Received: from public by hugh.gmane.org with local (Exim 4.63)
	(envelope-from <public@hugh.gmane.org>)
	id 1KAVQc-0005nQ-Mt
	for linux-wireless@vger.kernel.org; Sun, 22 Jun 2008 21:40:46 +0200
Message-ID: <485EAA82.30808@crespel.net> (sfid-20080622_214153_244801_12C8D0AD)
Date: Sun, 22 Jun 2008 21:39:46 +0200
From: Fabien Crespel <fabien@crespel.net>
MIME-Version: 1.0
To: Henrique de Moraes Holschuh
	<public-hmh-N3TV7GIv+o9fyO9Q7EP/yw@hugh.gmane.org>
Cc: John Linville
	<public-linville-2XuSBdqkA4R54TAoqtyWWQ@hugh.gmane.org>,
	public-linux-wireless-u79uwXL29TY76Z2rM5mHXA@hugh.gmane.org,
	Ivo van Doorn
	<public-ivdoorn-Re5JQEeQqe8AvxtiuMwx3w@hugh.gmane.org>,
	Matthew Garrett
	<public-mjg-H+wXaHxf7aLQT0dZR+AlfA@hugh.gmane.org>,
	Dan Williams <public-dcbw-H+wXaHxf7aLQT0dZR+AlfA@hugh.gmane.org>,
	Thomas Renninger <public-trenn-l3A5Bk7waGM@hugh.gmane.org>,
	Dmitry Torokhov <public-dtor-JGs/UdohzUI@hugh.gmane.org>
Subject: Re: [PATCH 11/12] rfkill: do not allow userspace to override ALL
 RADIOS OFF
References: <1214149128-5913-1-git-send-email-hmh@hmh.eng.br> <1214149128-5913-12-git-send-email-hmh@hmh.eng.br>
In-Reply-To: <1214149128-5913-12-git-send-email-hmh@hmh.eng.br>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>



Hello there,

I've been testing this series of patch today for a new version of asus-laptop, 
and this patch ("rfkill: do not allow userspace to override ALL RADIOS OFF") 
introduces a bug in rfkill-input.

rfkill_epo() doesn't change the current_state of the tasks, and the various calls 
to rfkill_schedule_set(..., RFKILL_STATE_ON) don't work if the last current_state 
stored was already RFKILL_STATE_ON.

Anyway, the whole current_state thing seems completely useless and a source of 
problems in rfkill-input, since state comparison is already done in rfkill, and 
rfkill-input is more than likely to become out of sync with the real state.

Therefore I propose this additional patch to remove current_state completely from 
rfkill-input.

- Fabien.

---

--- a/net/rfkill/rfkill-input.c	2008-06-22 21:16:15.000000000 +0200
+++ b/net/rfkill/rfkill-input.c	2008-06-22 21:20:01.000000000 +0200
@@ -30,27 +30,15 @@
  	spinlock_t lock; /* for accessing last and desired state */
  	unsigned long last; /* last schedule */
  	enum rfkill_state desired_state; /* on/off */
-	enum rfkill_state current_state; /* on/off */
  };

  static void rfkill_task_handler(struct work_struct *work)
  {
  	struct rfkill_task *task = container_of(work, struct rfkill_task, work);
-	enum rfkill_state state;

  	mutex_lock(&task->mutex);

-	/*
-	 * Use temp variable to fetch desired state to keep it
-	 * consistent even if rfkill_schedule_toggle() runs in
-	 * another thread or interrupts us.
-	 */
-	state = task->desired_state;
-
-	if (state != task->current_state) {
-		rfkill_switch_all(task->type, state);
-		task->current_state = state;
-	}
+	rfkill_switch_all(task->type, task->desired_state);

  	mutex_unlock(&task->mutex);
  }
@@ -94,7 +82,6 @@
  		.mutex = __MUTEX_INITIALIZER(n.mutex),	\
  		.lock = __SPIN_LOCK_UNLOCKED(n.lock),	\
  		.desired_state = RFKILL_STATE_ON,	\
-		.current_state = RFKILL_STATE_ON,	\
  	}

  static DEFINE_RFKILL_TASK(rfkill_wlan, RFKILL_TYPE_WLAN);


