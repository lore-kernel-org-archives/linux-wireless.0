Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mx2.redhat.com ([66.187.237.31]:60759 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752498AbYKEQ5Q (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Wed, 5 Nov 2008 11:57:16 -0500
Subject: Re: plan for libertas and mac80211 and cfg80211
From: Dan Williams <dcbw@redhat.com>
To: Cliff Brake <cliff.brake@gmail.com>
Cc: linux-wireless@vger.kernel.org
In-Reply-To: <f96d234e0811050728t63f3793eqc395ff979dafd9f6@mail.gmail.com>
References: <f96d234e0811050728t63f3793eqc395ff979dafd9f6@mail.gmail.com>
Content-Type: text/plain
Date: Wed, 05 Nov 2008 11:55:29 -0500
Message-Id: <1225904129.25627.7.camel@localhost.localdomain> (sfid-20081105_175719_182947_98437619)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Wed, 2008-11-05 at 10:28 -0500, Cliff Brake wrote:
> Hello,
> 
> I am using the marvell 8686 in several projects.  Is there any plan to
> move the libertas driver to mac80211 in the future?  If not, will

The libertas parts are "fullmac" parts, and implement most functionality
in firmware.  mac80211 is a "softmac" stack, which implements
functionality on the host CPU.  Thus, it's simply impossible to use
mac80211 with the fullmac libertas parts (838x, 838x).

Furthermore, that would be sort of counter to what the fullmac parts are
supposed to be, which is embedded, power-efficient parts that don't
require much interaction from the host CPU.

> cfg80211 mechanisms be supported with this driver?

Since cfg80211 itself is intended to be independent of mac80211, and
should be able to be used as the configuration interface for all
drivers, be they fullmac or softmac, yes.

Dan


