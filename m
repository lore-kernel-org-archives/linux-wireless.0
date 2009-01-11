Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from fk-out-0910.google.com ([209.85.128.184]:11206 "EHLO
	fk-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752715AbZAKLLZ (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sun, 11 Jan 2009 06:11:25 -0500
Received: by fk-out-0910.google.com with SMTP id 18so5141094fkq.5
        for <linux-wireless@vger.kernel.org>; Sun, 11 Jan 2009 03:11:23 -0800 (PST)
Message-ID: <1ba2fa240901110311o47fe2311w4717f5521c98aba@mail.gmail.com> (sfid-20090111_121149_817488_0BD8E316)
Date: Sun, 11 Jan 2009 13:11:23 +0200
From: "Tomas Winkler" <tomasw@gmail.com>
To: "Johannes Berg" <johannes@sipsolutions.net>
Subject: Re: [PATCH v2 0/3] mac80211 suspend/resume
Cc: "Marcel Holtmann" <marcel@holtmann.org>,
	"Dan Williams" <dcbw@redhat.com>,
	"Bob Copeland" <me@bobcopeland.com>,
	linux-wireless@vger.kernel.org, mabbaswireless@gmail.com
In-Reply-To: <1231579679.3685.10.camel@johannes>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
References: <1229313039-5544-1-git-send-email-me@bobcopeland.com>
	 <20081224054951.GA32398@hash.localnet>
	 <1230102989.16960.14.camel@californication>
	 <1231260306.14565.21.camel@localhost.localdomain>
	 <1231261937.5246.16.camel@californication>
	 <1231267979.14565.34.camel@localhost.localdomain>
	 <1231270575.14901.6.camel@californication>
	 <1231272326.3767.2.camel@johannes>
	 <1ba2fa240901091553s387c1a95k3576ce6a82015434@mail.gmail.com>
	 <1231579679.3685.10.camel@johannes>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Sat, Jan 10, 2009 at 11:27 AM, Johannes Berg
<johannes@sipsolutions.net> wrote:
> On Sat, 2009-01-10 at 01:53 +0200, Tomas Winkler wrote:
>
>> I second this by stressing another issue. in the point that
>> suspend/resume events shell be present to user space regardless of
>> mac80211 specific talk with wpa_supplicant. Not only Wifi but also in
>> my knowledge BT and other coms need user space application
>> to close gracefully connection before kernel shuts in down.
>
> But userspace is usually the one _invoking_ the suspend, so what I was
> trying to say is that we don't care what userspace did right before
> invoking suspend.

Exactly, so routing suspend event from mac80211 to wpa_supplicant or
NM just doesn't look right to me, if I understood properly Marcel
suggestion.

>
>> Even sometime leavening shutting down interface managing application
>> may reduce the crosstalk so that driver doesn't have go guess when
>> application has finished it's shutdown. rtnl is probably not enough as
>> there is still race who grabs it first.
>
> No, the rtnl definitely is enough right now since userspace will do
> whatever it needs to _before_ invoking the kernel suspend.
>
> I say we should just put these patches in as they are.

No objections to that.

Tomas
