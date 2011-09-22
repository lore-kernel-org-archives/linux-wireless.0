Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-ey0-f174.google.com ([209.85.215.174]:32875 "EHLO
	mail-ey0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751987Ab1IVSjE (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 22 Sep 2011 14:39:04 -0400
Received: by eya28 with SMTP id 28so1775116eya.19
        for <linux-wireless@vger.kernel.org>; Thu, 22 Sep 2011 11:39:03 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <1316691605.3899.43.camel@jlt3.sipsolutions.net>
References: <1316082334-7664-1-git-send-email-arik@wizery.com>
 <1316082334-7664-3-git-send-email-arik@wizery.com> <1316606713.3940.29.camel@jlt3.sipsolutions.net>
 <CA+XVXffOFw9RFFuwDTB_ei6Ktwai1tCicTuTeF5=4=WqZSZafw@mail.gmail.com> <1316691605.3899.43.camel@jlt3.sipsolutions.net>
From: Arik Nemtsov <arik@wizery.com>
Date: Thu, 22 Sep 2011 21:38:48 +0300
Message-ID: <CA+XVXfc3QC24PuKZ-FMXmUqH-XLgR7xp0=z--oH3UvSJBUz_xg@mail.gmail.com> (sfid-20110922_203908_350819_038830DD)
Subject: Re: [RFC 2/5] mac80211: handle TDLS high-level commands and frames
To: Johannes Berg <johannes@sipsolutions.net>
Cc: Kalyan C Gaddam <chakkal@iit.edu>,
	Jouni Malinen <jouni@qca.qualcomm.com>,
	linux-wireless@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Thu, Sep 22, 2011 at 14:40, Johannes Berg <johannes@sipsolutions.net> wrote:

>> The race is even worse - from queuing until the actual Tx, we could
>> have disconnected from this AP and connected do a totally different
>> one. But this shouldn't happen in reality (and we can add some guards
>> to wpa_supplicant to make sure).
>> Do you see this as a security threat?
>
> I don't really know :-) I just saw the possible race here. If you remove
> the TDLS station entries when disassociating then it shouldn't be an
> issue, right? Since you require a station entry pretty early on anyway.

As discussed on IRC - this race is not really an issue. In the next
version of the patch stations will be purged by kernel-mode on
disassociation.

Arik
