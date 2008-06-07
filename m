Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from wa-out-1112.google.com ([209.85.146.182]:13573 "EHLO
	wa-out-1112.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751115AbYFGMJ4 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sat, 7 Jun 2008 08:09:56 -0400
Received: by wa-out-1112.google.com with SMTP id j37so1096987waf.23
        for <linux-wireless@vger.kernel.org>; Sat, 07 Jun 2008 05:09:55 -0700 (PDT)
Message-ID: <1ba2fa240806070509p51d7b8f6lfee9b28f17ee8ea2@mail.gmail.com> (sfid-20080607_141001_855174_C9C22B4D)
Date: Sat, 7 Jun 2008 15:09:55 +0300
From: "Tomas Winkler" <tomasw@gmail.com>
To: "Dan Williams" <dcbw@redhat.com>,
	"Henrique de Moraes Holschuh" <hmh@hmh.eng.br>
Subject: Re: [PATCH 01/12] rfkill: clarify meaning of rfkill states
Cc: "John W. Linville" <linville@tuxdriver.com>,
	"Ivo van Doorn" <ivdoorn@gmail.com>,
	linux-wireless@vger.kernel.org, "Dmitry Torokhov" <dtor@mail.ru>
In-Reply-To: <1212762451.28631.3.camel@localhost.localdomain>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
References: <1212549017-30144-2-git-send-email-hmh@hmh.eng.br>
	 <20080605003808.GA16599@khazad-dum.debian.net>
	 <1212667955.25730.29.camel@localhost.localdomain>
	 <20080605130323.GB3413@khazad-dum.debian.net>
	 <1212677207.28545.56.camel@localhost.localdomain>
	 <1212696826.13915.1256967905@webmail.messagingengine.com>
	 <1212722763.1026.17.camel@localhost.localdomain>
	 <1212758662.26514.5.camel@localhost.localdomain>
	 <20080606141419.GA3444@khazad-dum.debian.net>
	 <1212762451.28631.3.camel@localhost.localdomain>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

This is how I view the requirements/state of rfkill system. Not trying
to come with any design yet or mapping it to what we currently have in
rfkill. Just clearing the table for myself and maybe others.

1. radio state is inclusive disjunction or conjunction of all rfkill
switches (depends on what 0,1 means)
   * user space and kernel components (e.g. mac80211) must be notified
about change in radio state
2. rfkill switches types
 a. sw - can be switched by software means
 b. hw - must be manually toggled..
 c. devices switch - switch has direct connection to device (hw switches only)
     device provides the input to the radio state
 c. input switch - device is requested to change radio state (hw and
sw switches)
3. state of each rfkill switch has to be visible to user space, also
sw and hw attributes of switch must be known to user space.
4. switch state must be preserved across reboot and suspend/resume,
  hw switch of course might be changed even when computer is powered off
5. There must be at least one sw input switch.


Tomas
