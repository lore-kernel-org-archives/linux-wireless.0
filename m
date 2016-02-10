Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from s3.sipsolutions.net ([5.9.151.49]:33367 "EHLO sipsolutions.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751060AbcBJQHj (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Wed, 10 Feb 2016 11:07:39 -0500
Message-ID: <1455120444.4991.1.camel@sipsolutions.net> (sfid-20160210_170802_866757_0982097B)
Subject: Re: [PATCH 8/9] rfkill: Userspace control for airplane mode
From: Johannes Berg <johannes@sipsolutions.net>
To: Dan Williams <dcbw@redhat.com>,
	=?ISO-8859-1?Q?Jo=E3o?= Paulo Rechi Vita <jprvita@gmail.com>
Cc: "David S. Miller" <davem@davemloft.net>,
	Darren Hart <dvhart@infradead.org>,
	linux-wireless@vger.kernel.org, netdev@vger.kernel.org,
	platform-driver-x86@vger.kernel.org, linux-api@vger.kernel.org,
	linux-doc@vger.kernel.org, linux-kernel@vger.kernel.org,
	linux@endlessm.com,
	=?ISO-8859-1?Q?Jo=E3o?= Paulo Rechi Vita
	<jprvita@endlessm.com>
Date: Wed, 10 Feb 2016 17:07:24 +0100
In-Reply-To: <1454947887.5325.8.camel@redhat.com>
References: <1454946096-9752-1-git-send-email-jprvita@endlessm.com>
	 <1454946096-9752-9-git-send-email-jprvita@endlessm.com>
	 <1454947887.5325.8.camel@redhat.com>
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Mon, 2016-02-08 at 10:11 -0600, Dan Williams wrote:
> I'd like to clarify a bit, so tell me if I'm correct or not.  Using
> RFKILL_OP_AIRPLANE_MODE_CHANGE does not actually change any device
> state. It's just an indicator with no relationship to any of the
> registered rfkill switches, right?

Yes. I'm not sure I'm totally happy with this userspace API.

> I wonder if setting RFKILL_OP_AIRPLANE_MODE_CHANGE(true) shouldn't
> also
> softblock all switches, otherwise you can set airplane mode all day
> long with RFKILL_OP_AIRPLANE_MODE_CHANGE and it doesn't actually
> enable
> airplane mode at all?

No, this is kinda the point that you could implement your policy in
userspace now.

johannes
