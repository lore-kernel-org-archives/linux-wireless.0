Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-vb0-f46.google.com ([209.85.212.46]:35794 "EHLO
	mail-vb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751136Ab2IGGyD (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 7 Sep 2012 02:54:03 -0400
Received: by vbbff1 with SMTP id ff1so2681482vbb.19
        for <linux-wireless@vger.kernel.org>; Thu, 06 Sep 2012 23:54:02 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <20120906224448.GA16676@khazad-dum.debian.net>
References: <5048ADFC.1010708@sonymobile.com>
	<20120906224448.GA16676@khazad-dum.debian.net>
Date: Fri, 7 Sep 2012 08:54:02 +0200
Message-ID: <CAMJBoFMd2sLEScY3j2-wsWQh3Mv_nArPC904dzJ+j-16+pdkgQ@mail.gmail.com> (sfid-20120907_085419_412505_9AEB3D7E)
Subject: Re: [PATCH/RFC] rfkill: prevent unnecessary event generation
From: Vitaly Wool <vitalywool@gmail.com>
To: Henrique de Moraes Holschuh <hmh@hmh.eng.br>
Cc: Vitaly Wool <vitaly.wool@sonymobile.com>,
	linux-wireless@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi Henrique,

On Fri, Sep 7, 2012 at 12:44 AM, Henrique de Moraes Holschuh
<hmh@hmh.eng.br> wrote:
>
> On Thu, 06 Sep 2012, Vitaly Wool wrote:
> > Prevent unnecessary rfkill event generation when the state has
> > not actually changed. These events have to be delivered to
> > relevant userspace processes, causing these processes to wake
> > up and do something while they could as well have slept. This
> > obviously results in more CPU usage, longer time-to-sleep-again
> > and therefore higher power consumption.
>
> Could this supress the first event when a switch is registered? Would that
> be a concern?

I'm not sure I got your question, but just in case, rfkill is
initialized to all zeroes so rfkill->state is 0 and on each consequent
_real_ change there (prev != curr) == true and the event will be
generated.

~Vitaly
