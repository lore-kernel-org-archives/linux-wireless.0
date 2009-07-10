Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-pz0-f197.google.com ([209.85.222.197]:40361 "EHLO
	mail-pz0-f197.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754761AbZGJUho (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 10 Jul 2009 16:37:44 -0400
Received: by pzk35 with SMTP id 35so72015pzk.33
        for <linux-wireless@vger.kernel.org>; Fri, 10 Jul 2009 13:37:43 -0700 (PDT)
MIME-Version: 1.0
Date: Fri, 10 Jul 2009 13:37:43 -0700
Message-ID: <45e8e6c40907101337t2e0cf5bcufa4e8acc8b88221f@mail.gmail.com>
Subject: detecting excessive TX errors?
From: Andrey Yurovsky <andrey@cozybit.com>
To: linux-wireless <linux-wireless@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

The mesh code provides mesh_plink_broken(), which needs to be called
when we detect excessive TX retries / errors, which indicate that the
current plink is no longer usable.  That function will then send a
mesh Path Error as needed.  The old rc80211_pid_algo called this but
Minstrel does not, and there are other RC algorithms as well.  Is
there a generic and more correct place for us to detect a broken path
and call this function that fits in to the current design?  Thanks,

  -Andrey
