Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mx51.mymxserver.com ([85.199.173.110]:49506 "EHLO
	mx51.mymxserver.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751478AbYHMGwU (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 13 Aug 2008 02:52:20 -0400
From: Holger Schurig <hs4233@mail.mn-solutions.de>
To: linux-wireless@vger.kernel.org
Subject: Re: Pondering: how to improve mac80211 roaming ...
Date: Wed, 13 Aug 2008 08:52:15 +0200
Cc: Jouni Malinen <j@w1.fi>
References: <200808120838.52888.hs4233@mail.mn-solutions.de> <20080812082246.GD4981@jm.kir.nu>
In-Reply-To: <20080812082246.GD4981@jm.kir.nu>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Message-Id: <200808130852.15051.hs4233@mail.mn-solutions.de> (sfid-20080813_085223_372243_60E0B89C)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

> cfg80211 lacks a command for request new scans, so that could
> also be an area that would benefit of improvements if the
> current SIOCSIWSCAN WE ioctl does not provide all the
> functionality needed for this (though, it may be more because
> of SIOCSIWSCAN handler in mac80211 lacking support for many of
> the options).

If cfg80211 get's a scan command, it should probably get more 
than one command:

* command "do scan" with lot's of options, e.g. band, channels,
  ESSID, active/passive

* a notification from mac80211->userspace "scan completed"

* command "get current scan list"
  - this command should not return the equivalent of -EAGAIN
  - always return the whole list, even if one process asked
    a "do scan" with ESSID "MUH" and another process asked
    a "do scan" with ESSID "BLAH" one second later
  - filtering/sorting should be done in user-space
