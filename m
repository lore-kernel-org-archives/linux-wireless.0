Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from fg-out-1718.google.com ([72.14.220.157]:1157 "EHLO
	fg-out-1718.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751711AbZAIXyA (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 9 Jan 2009 18:54:00 -0500
Received: by fg-out-1718.google.com with SMTP id 19so3549454fgg.17
        for <linux-wireless@vger.kernel.org>; Fri, 09 Jan 2009 15:53:58 -0800 (PST)
Message-ID: <1ba2fa240901091553s387c1a95k3576ce6a82015434@mail.gmail.com> (sfid-20090110_005408_113702_695788B2)
Date: Sat, 10 Jan 2009 01:53:58 +0200
From: "Tomas Winkler" <tomasw@gmail.com>
To: "Johannes Berg" <johannes@sipsolutions.net>
Subject: Re: [PATCH v2 0/3] mac80211 suspend/resume
Cc: "Marcel Holtmann" <marcel@holtmann.org>,
	"Dan Williams" <dcbw@redhat.com>,
	"Bob Copeland" <me@bobcopeland.com>,
	linux-wireless@vger.kernel.org, mabbaswireless@gmail.com
In-Reply-To: <1231272326.3767.2.camel@johannes>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
References: <1229313039-5544-1-git-send-email-me@bobcopeland.com>
	 <20081217174244.M36761@bobcopeland.com>
	 <1230064216.31228.46.camel@johannes>
	 <20081224054951.GA32398@hash.localnet>
	 <1230102989.16960.14.camel@californication>
	 <1231260306.14565.21.camel@localhost.localdomain>
	 <1231261937.5246.16.camel@californication>
	 <1231267979.14565.34.camel@localhost.localdomain>
	 <1231270575.14901.6.camel@californication>
	 <1231272326.3767.2.camel@johannes>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Tue, Jan 6, 2009 at 10:05 PM, Johannes Berg
<johannes@sipsolutions.net> wrote:
> On Tue, 2009-01-06 at 20:36 +0100, Marcel Holtmann wrote:
>
>> since mac80211 gets suspend/resume support, I think it is the best that
>> we signal this to wpa_supplicant. In that case it can do the hard work
>> here. Either it re-connects to the last AP or signals a disconnected
>> state or trigger scanning.
>
> Let me just say once again that all this discussion is entirely
> orthogonal to properly supporting suspend/resume in mac80211, it's
> always possible for userspace to do anything with the devices before
> going into suspend, but the kernel should take some care to resume as it
> was at suspend time, which is what we're aiming for here. Of course,
> this may mean that at resume we lose the AP connection that we think we
> still have right away, but that's great since then wpa_supplicant will
> reconnect quickly.

I second this by stressing another issue. in the point that
suspend/resume events shell be present to user space regardless of
mac80211 specific talk with wpa_supplicant. Not only Wifi but also in
my knowledge BT and other coms need user space application
to close gracefully connection before kernel shuts in down.
Even sometime leavening shutting down interface managing application
may reduce the crosstalk so that driver doesn't have go guess when
application has finished it's shutdown. rtnl is probably not enough as
there is still race who grabs it first.

Thanks
Tomas
