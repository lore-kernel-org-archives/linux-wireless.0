Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-vc0-f182.google.com ([209.85.220.182]:37112 "EHLO
	mail-vc0-f182.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754679AbaIICGh (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 8 Sep 2014 22:06:37 -0400
Received: by mail-vc0-f182.google.com with SMTP id le20so2346621vcb.27
        for <linux-wireless@vger.kernel.org>; Mon, 08 Sep 2014 19:06:36 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <1410182120.7983.12.camel@jlt4.sipsolutions.net>
References: <1410156082-17313-1-git-send-email-yeohchunyeow@gmail.com>
	<20140908122454.GA29495@localhost>
	<1410182120.7983.12.camel@jlt4.sipsolutions.net>
Date: Tue, 9 Sep 2014 10:06:36 +0800
Message-ID: <CAEFj985BmM7jqeGE1QcA7KvfoNW_8Ze=o79d0k7dTKH_q3MxEw@mail.gmail.com> (sfid-20140909_040640_780370_0600BA53)
Subject: Re: [PATCH] {nl, cfg, mac}80211: Implement hidden mesh ID
From: Yeoh Chun-Yeow <yeohchunyeow@gmail.com>
To: Johannes Berg <johannes@sipsolutions.net>
Cc: Bob Copeland <me@bobcopeland.com>,
	"devel@lists.open80211s.org" <devel@lists.open80211s.org>,
	"linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
	John Linville <linville@tuxdriver.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Mon, Sep 8, 2014 at 9:15 PM, Johannes Berg <johannes@sipsolutions.net> wrote:
> On Mon, 2014-09-08 at 08:24 -0400, Bob Copeland wrote:
>> On Mon, Sep 08, 2014 at 02:01:22PM +0800, Chun-Yeow Yeoh via Devel wrote:
>> > The hidden mesh ID is use to enhance the security of
>> > open mesh and possible secured mesh later on by not
>> > advertising the mesh ID during beacon generation,
>> > similar to hidden SSID implemented in AP mode.
>>
>> I'm unconvinced - hidden SSID is not much of a security feature and it
>> seems like this would break all manner of things.  Is it really worth
>> the pain when people can just use a secure mesh instead?
>
> It's certainly not a security feature at all.
>
> So why bother introducing the old hidden SSID mistake again in a new
> protocol? It caused all kinds of pain there, and almost certainly will,
> and there already are few implementations to interoperate with and this
> is likely to not interoperate at all, right?
>

Thanks for the comment from all.

In term of interoperability, I have to agree on this since this is not
part of the standard. I thought that this is only offering an option
for the static "open" mesh deployment. At least, by hiding the mesh
ID, ordinary user won't be able to find my mesh network and connecting
to my network due to not enabling the security in my mesh deployment.
I do agree with Bob that enabling the secured mesh is still a better
approach.

> I really don't think we should allow this. If you need to hide the
> network name then maybe just give it a random/useless name?

Yes, randomize the mesh ID could be another option. iOS 8 also tends
to randomize the MAC address while sending the probe request frame. It
is one option to hide from other peoples tracking your device. So
perhaps this can be done on the wap_supp for mesh ID just need to
figure out the frequency of doing so.

I am alright to drop this if interoperability is our main concern.
Hope to see more "mesh-friendly" chipset soon.

----
Chun-Yeow
