Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-vb0-f46.google.com ([209.85.212.46]:64581 "EHLO
	mail-vb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751826Ab3IIGQs convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 9 Sep 2013 02:16:48 -0400
Received: by mail-vb0-f46.google.com with SMTP id p13so3575918vbe.5
        for <linux-wireless@vger.kernel.org>; Sun, 08 Sep 2013 23:16:48 -0700 (PDT)
MIME-Version: 1.0
Date: Mon, 9 Sep 2013 08:16:47 +0200
Message-ID: <CAFSJ42bTQkQO+yugN7BBjygQd7LY9H0bPBoPfoH7yyfyMzuGqA@mail.gmail.com> (sfid-20130909_081651_849743_82620A8F)
Subject: regulatory will stuck when cfg80211 is built-in
From: Eugene Krasnikov <k.eugene.e@gmail.com>
To: linux-wireless <linux-wireless@vger.kernel.org>
Content-Type: text/plain; charset=windows-1252
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi All,

There is a problem with regulatory part of cfg80211 when cfg80211 is
built-in the kernel. On regulatory init cfg80211 will try to notify
user space about changing current domain to world regulatory but at
that time user space is not up and running yet and uevent message will
be lost. So what will happen is that cfg80211 will wait for the
response from user space and all requests to set current regulatory
will be dropped with the following error: “Pending regulatory request,
waiting for it to be processed...”.

I assume the problem is known so is there any information on wiki how
to fix this in official way? Of course one option is to have cfg80211
as a module but is it really the right wait to go?


-- 
Best regards,
Eugene
