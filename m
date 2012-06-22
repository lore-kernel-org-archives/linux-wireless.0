Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from he.sipsolutions.net ([78.46.109.217]:59230 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932788Ab2FVMXX (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 22 Jun 2012 08:23:23 -0400
Message-ID: <1340367797.4491.21.camel@jlt3.sipsolutions.net> (sfid-20120622_142326_982388_3162DE64)
Subject: dynamic debug
From: Johannes Berg <johannes@sipsolutions.net>
To: Joe Perches <joe@perches.com>, Jim Cromie <jim.cromie@gmail.com>,
	Jason Baron <jbaron@redhat.com>
Cc: linux-wireless <linux-wireless@vger.kernel.org>
Date: Fri, 22 Jun 2012 14:23:17 +0200
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Joe, Jim, Jason,

Joe's conversion of mac80211 to pr_debug() was pretty much a disaster,
now people have to first select what they want in Kconfig, and then
still enable dynamic debug in debugfs... That doesn't make any sense at
all, and requires teaching everybody new tricks, so I'm basically
reverting it for now in favour of pr_info() instead of pr_debug().

I'd actually not mind using pr_debug() if it meant we could get rid of
all the Kconfig symbols, but that's not possible.

The biggest problem here really is that the dynamic debug infrastructure
lets us enable messages at runtime, which is great, but the granularity
is useless since you only have these possibilities:
 * module name
 * file name
 * function name
 * line number
 * format string match

The module is obviously way too broad for most modules, and the others
are way too fine-grained.

To actually make it useful, there needs to be a "key" that you can use,
e.g. in mac80211 I could do

DECLARE_DYNDBG_KEY(ps);

and in some C file, I'd have to do the matching DEFINE_DYNDBG_KEY(ps),
similar to how tracing works.

Then, I would get

 * an inline function ps_dbg()
 * a macro "is_ps_debug" or so, so that you can use the enable/disable
   bit of this key, say to create wrappers like netdev_ps_dbg
   (probably needs to be a macro if it uses jump labels which it should
   I think)

and probably some other magic. The DEFINE_ macro would create some
structure, and that would go into some special module section, so that
then the dyn debug core can collect all these keys and allow us to do
something like

 echo mac80211:ps > dynamic_debug/control

That would actually allow us to get rid of all our own Kconfig symbols
and would allow a lot of drivers to get rid of their own infrastructure
for enabling/disabling certain "log levels" etc...

johannes

