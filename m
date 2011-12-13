Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from he.sipsolutions.net ([78.46.109.217]:37856 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753301Ab1LMUPQ (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 13 Dec 2011 15:15:16 -0500
Received: by sipsolutions.net with esmtpsa (TLS1.0:RSA_AES_256_CBC_SHA1:32)
	(Exim 4.77)
	(envelope-from <johannes@sipsolutions.net>)
	id 1RaYks-00036M-Kc
	for linux-wireless@vger.kernel.org; Tue, 13 Dec 2011 21:15:14 +0100
Message-Id: <20111213200717.465896579@sipsolutions.net> (sfid-20111213_211519_623701_281D3ED6)
Date: Tue, 13 Dec 2011 21:07:17 +0100
From: Johannes Berg <johannes@sipsolutions.net>
To: linux-wireless@vger.kernel.org
Subject: [RFC 0/4] refactor station state management
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Here's a first step towards something I talked to some
of you about -- making drivers more aware of station
state.

Because experience tells me that drivers will be written
for the common case, and forget about uncommon sequences,
this first step enforces proper ordering of states, now
a station can move only between these states like this:
 NONE  <--> AUTHENTICATED <--> ASSOCIATED <--> AUTHORIZED

As a consequence, IBSS stations and WDS peers need to
go through ASSOCIATED state (and get ASSOC flag set),
but this doesn't seem to be an issue, in fact it makes
at least one place in the code simpler.

This patchset still has two issues:
 * secure mesh is broken right now I think, its state
   change possibilities are rather confusing
   (need help to fix this, at least explanations)
 * TLDS isn't handled (maybe not an issue?)


My further plan is the following:
 1) figure out the issues above
 2) notify drivers of these state changes
 3) refactor auth/assoc process as described before
  a) don't track multiple authentications
  b) don't try to keep an existing authentication/association
  c) set channel first etc.
 4) remove dummy station code
  a) add regular station entry before auth
  b) notify to AUTH state when auth succeeds
  c) notify to ASSOC state when assoc succeeds

This patchset is but the first step on this journey, at the
end of which we will hopefully find multi-channel support :-)

johannes
