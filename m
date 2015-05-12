Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-pd0-f179.google.com ([209.85.192.179]:33254 "EHLO
	mail-pd0-f179.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932924AbbELSdV (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 12 May 2015 14:33:21 -0400
From: "Luis R. Rodriguez" <mcgrof@do-not-panic.com>
To: ming.lei@canonical.com, rusty@rustcorp.com.au
Cc: dhowells@redhat.com, seth.forshee@canonical.com,
	torvalds@linux-foundation.org, linux-kernel@vger.kernel.org,
	pebolle@tiscali.nl, linux-wireless@vger.kernel.org,
	"Luis R. Rodriguez" <mcgrof@suse.com>
Subject: [PATCH v2 0/5] firmware: few fixes for name uses
Date: Tue, 12 May 2015 11:30:52 -0700
Message-Id: <1431455457-25322-1-git-send-email-mcgrof@do-not-panic.com> (sfid-20150512_203325_100772_92A7844A)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: "Luis R. Rodriguez" <mcgrof@suse.com>

This is a follow up to my original series that added kernel firmware
signature check support. That series was split into 3 parts, one which
had fixes, a second set which added firmware signature support, and
a last set which provided system data firmware support as a spring
cleaning effort on the firmware_class driver API. During review I've
spotted even more fixes required on firmware_class, because of this
and in order to help make the review easier I'm splitting the series
out completely. This series only addresses fixes and enhancements for
firmware_class. When reviewing these please keep in mind that one of
the end goals here is to eventually add address firmware signature support,
this means we want to be pretty pedantic and careful about how we handle
names and files.

I've removed Cc: stable notations because although they are fixes they
don't really fix any reported issues even though I can trigger at least
one panic on demand, I'll let Greg and others decide what patches should
be merged in and trickled down to stable. Its not an easy judgement call,
and because of this I've tried to split out fixes out as atomically as
possible. If its of any help I think the Patch 1-2, 4, should all go
in to stable while Patch 3, 5 can be considered optimizations which are
not really stable fixes.

Luis R. Rodriguez (5):
  firmware: fix __getname() missing failure check
  firmware: check for file truncation on direct firmware loading
  firmware: check for possible file truncation early
  firmware: fix possible use after free on name on asynchronous request
  firmware: use const for remaining firmware names

 drivers/base/firmware_class.c | 110 ++++++++++++++++++++++++++++++++++--------
 1 file changed, 91 insertions(+), 19 deletions(-)

-- 
2.3.2.209.gd67f9d5.dirty

