Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-wg0-f44.google.com ([74.125.82.44]:48066 "EHLO
	mail-wg0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754398Ab2KSTAm (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 19 Nov 2012 14:00:42 -0500
Received: by mail-wg0-f44.google.com with SMTP id dr13so3035836wgb.1
        for <linux-wireless@vger.kernel.org>; Mon, 19 Nov 2012 11:00:41 -0800 (PST)
MIME-Version: 1.0
From: Javier Cardona <javier@cozybit.com>
Date: Mon, 19 Nov 2012 11:00:20 -0800
Message-ID: <CAPjQAd_2nr7Mafm3cEB6DRP7+Yy5v4LSgLzfXs3JjC5Bu3y-zg@mail.gmail.com> (sfid-20121119_200045_521564_16ADB3BC)
Subject: Recent change in netns/unshare behavior regarding phy's
To: linux-wireless <linux-wireless@vger.kernel.org>
Cc: devel@lists.open80211s.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi,

We recently noticed a change in behaviour that broke some of our
tests.  We normally run multiple phy's on different namespaces.  In
the past we could "pull" a phy from one namespace (ns1) into another
(ns2) by name.  E.g. if ns1 had two phy's (phy0 and phy1), we could
execute the following in ns2:

iw phy phy1 set netns $BASHPID

and that would pull phy1 into ns2.

We cannot do this anymore.  The above command only works from ns1
(i.e. "pushing" a phy from the namespace that owns it into another).
This makes scripting a bit more complicated as ns1 needs to know the
pid associated with ns2 (you can see the broken script here:
https://github.com/cozybit/open80211s/wiki/HwsimTestTemplate)

Does anyone if this change was intended?

Cheers,

Javier

-- 
Javier Cardona
cozybit Inc.
http://www.cozybit.com
