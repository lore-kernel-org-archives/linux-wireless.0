Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-pz0-f46.google.com ([209.85.210.46]:54915 "EHLO
	mail-pz0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751002Ab2BDBZx (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 3 Feb 2012 20:25:53 -0500
Received: by dadp15 with SMTP id p15so3176528dad.19
        for <linux-wireless@vger.kernel.org>; Fri, 03 Feb 2012 17:25:52 -0800 (PST)
From: "Luis R. Rodriguez" <mcgrof@frijolero.org>
To: linux-wireless@vger.kernel.org
Cc: "Luis R. Rodriguez" <mcgrof@frijolero.org>
Subject: [RFC 00/11] crda: start combing code for library
Date: Fri,  3 Feb 2012 17:25:37 -0800
Message-Id: <1328318748-21044-1-git-send-email-mcgrof@frijolero.org> (sfid-20120204_022600_783774_AC31D1E4)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

I've had these sittng in my queueu for a while, so here they are.  Its code
that starts combing CRDA to allow for a small library to be later extracted to
be shared between CRDA and the regulatory simulator [0].

Sending these out for review. The library isn't split yet but I figured I'd
send this out for review so far. I've decided to go with a compromise and
simplify the library by only letting the library deal with reads from the
database file atomically. I think the benefit is cleaner code without having to
shuffle and keep some local mmap()'d value somewhere.

Anyway, let me know if this seems agreeable.

[0] git://github.com/mcgrof/regsim.git

Luis R. Rodriguez (11):
  crda: move country2rd() and its helper to reglib.c
  crda: add a reglib iterator reglib_for_each_country()
  crda: make intersect.c use reglib_for_each_country()
  crda: close fd upon leaving
  crda: add new reglib_get_country_alpha2()
  crda: add dfs_region to the ieee80211_regdomain data structure
  crda: make crda use reglib_get_country_alpha2()
  crda: clean header files
  crda: make country2rd() static
  crda: make usage of regdb.h exclusive to reglib.c
  crda: rename reglib_get_*() routines

 Makefile       |    2 +-
 crda.c         |  114 +++++++------------------------
 intersect.c    |   96 +++-----------------------
 print-regdom.c |   80 +++-------------------
 regdbdump.c    |   82 +---------------------
 reglib.c       |  207 ++++++++++++++++++++++++++++++++++++++++++++++++++++++++
 reglib.h       |   17 +++--
 7 files changed, 272 insertions(+), 326 deletions(-)

-- 
1.7.4.15.g7811d

