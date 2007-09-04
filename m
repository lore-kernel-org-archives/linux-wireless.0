Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from fk-out-0910.google.com ([209.85.128.190]:63698 "EHLO
	fk-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755213AbXIDSFk (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 4 Sep 2007 14:05:40 -0400
Received: by fk-out-0910.google.com with SMTP id z23so1714046fkz
        for <linux-wireless@vger.kernel.org>; Tue, 04 Sep 2007 11:05:38 -0700 (PDT)
To: dragoran <drago01@gmail.com>
Subject: Re: [PATCH V3] Add iwlwifi wireless drivers
Date: Tue, 4 Sep 2007 20:15:34 +0200
Cc: linux-wireless@vger.kernel.org, johannes@sipsolutions.net
References: <f6ca9fed0709041056rf44bb78ic7b5a516d6a3187a@mail.gmail.com>
In-Reply-To: <f6ca9fed0709041056rf44bb78ic7b5a516d6a3187a@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Message-Id: <200709042015.34764.IvDoorn@gmail.com>
From: Ivo van Doorn <ivdoorn@gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Tuesday 04 September 2007, dragoran wrote:
> >+static ssize_t show_rf_kill(struct device *d,
> >+			    struct device_attribute *attr, char *buf)
> >+{
> >+	/*
> >+	 * 0 - RF kill not enabled
> >+	 * 1 - SW based RF kill active (sysfs)
> >+	 * 2 - HW based RF kill active
> >+	 * 3 - Both HW and SW based RF kill active
> >
> >that as well, along with all the other sysfs bits. Also, how about using
> >the generic rfkill infrastructure Ivo did?
> 
> is the generic rfkill interface already stable and merged into the linus tree?

Yes. It currently is only missing users.

> if not please leave this for now to not break userspace (hal).
> hal currently is using this on all ipw* and iwl* drivers to get and
> set the rfkill status. And NM uses this interface to set/get rfkill
> status.
> 
> So please don't remove this yet until the proper interface is merged
> too (which should be better anyway because this one requires polling)

The input-polldev interface could be used for polling if it is required.

Ivo
