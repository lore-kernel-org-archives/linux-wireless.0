Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from wa-out-1112.google.com ([209.85.146.176]:44575 "EHLO
	wa-out-1112.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755042AbXIDSS6 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 4 Sep 2007 14:18:58 -0400
Received: by wa-out-1112.google.com with SMTP id v27so2311963wah
        for <linux-wireless@vger.kernel.org>; Tue, 04 Sep 2007 11:18:57 -0700 (PDT)
Message-ID: <f6ca9fed0709041118o2dcd4b18mcb25f2b93f648479@mail.gmail.com>
Date: Tue, 4 Sep 2007 20:18:57 +0200
From: dragoran <drago01@gmail.com>
To: "Ivo van Doorn" <ivdoorn@gmail.com>
Subject: Re: [PATCH V3] Add iwlwifi wireless drivers
Cc: linux-wireless@vger.kernel.org, johannes@sipsolutions.net
In-Reply-To: <200709042015.34764.IvDoorn@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
References: <f6ca9fed0709041056rf44bb78ic7b5a516d6a3187a@mail.gmail.com>
	 <200709042015.34764.IvDoorn@gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 9/4/07, Ivo van Doorn <ivdoorn@gmail.com> wrote:
> On Tuesday 04 September 2007, dragoran wrote:
> > >+static ssize_t show_rf_kill(struct device *d,
> > >+                        struct device_attribute *attr, char *buf)
> > >+{
> > >+    /*
> > >+     * 0 - RF kill not enabled
> > >+     * 1 - SW based RF kill active (sysfs)
> > >+     * 2 - HW based RF kill active
> > >+     * 3 - Both HW and SW based RF kill active
> > >
> > >that as well, along with all the other sysfs bits. Also, how about using
> > >the generic rfkill infrastructure Ivo did?
> >
> > is the generic rfkill interface already stable and merged into the linus tree?
>
> Yes. It currently is only missing users.

ok thats great ;) is the (userspace) interface defined somewhere? or
should I read the code to understand how it works? (would like to add
support to hal)

> > if not please leave this for now to not break userspace (hal).
> > hal currently is using this on all ipw* and iwl* drivers to get and
> > set the rfkill status. And NM uses this interface to set/get rfkill
> > status.
> >
> > So please don't remove this yet until the proper interface is merged
> > too (which should be better anyway because this one requires polling)
>
> The input-polldev interface could be used for polling if it is required.

shouldn't the new interface send events so that polling isn't required?
