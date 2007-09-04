Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from wa-out-1112.google.com ([209.85.146.182]:60920 "EHLO
	wa-out-1112.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754932AbXIDR4i (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 4 Sep 2007 13:56:38 -0400
Received: by wa-out-1112.google.com with SMTP id v27so2305759wah
        for <linux-wireless@vger.kernel.org>; Tue, 04 Sep 2007 10:56:38 -0700 (PDT)
Message-ID: <f6ca9fed0709041056rf44bb78ic7b5a516d6a3187a@mail.gmail.com>
Date: Tue, 4 Sep 2007 19:56:37 +0200
From: dragoran <drago01@gmail.com>
To: linux-wireless@vger.kernel.org
Subject: Re: [PATCH V3] Add iwlwifi wireless drivers
Cc: johannes@sipsolutions.net
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

>+static ssize_t show_rf_kill(struct device *d,
>+			    struct device_attribute *attr, char *buf)
>+{
>+	/*
>+	 * 0 - RF kill not enabled
>+	 * 1 - SW based RF kill active (sysfs)
>+	 * 2 - HW based RF kill active
>+	 * 3 - Both HW and SW based RF kill active
>
>that as well, along with all the other sysfs bits. Also, how about using
>the generic rfkill infrastructure Ivo did?

is the generic rfkill interface already stable and merged into the linus tree?
if not please leave this for now to not break userspace (hal).
hal currently is using this on all ipw* and iwl* drivers to get and
set the rfkill status. And NM uses this interface to set/get rfkill
status.

So please don't remove this yet until the proper interface is merged
too (which should be better anyway because this one requires polling)
