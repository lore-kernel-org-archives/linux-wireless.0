Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from rv-out-0506.google.com ([209.85.198.238]:33957 "EHLO
	rv-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754198AbYLEXxU (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 5 Dec 2008 18:53:20 -0500
Received: by rv-out-0506.google.com with SMTP id k40so224337rvb.1
        for <linux-wireless@vger.kernel.org>; Fri, 05 Dec 2008 15:53:18 -0800 (PST)
Message-ID: <b3153e950812051553r2035b8aex4f54f6cf704a26b3@mail.gmail.com> (sfid-20081206_005325_982861_8D8FA294)
Date: Fri, 5 Dec 2008 15:53:18 -0800
From: "mohamed salim abbas" <mabbaswireless@gmail.com>
To: "Tomas Winkler" <tomasw@gmail.com>
Subject: Re: [RFC] mac80211: remove ieee80211_notify_mac
Cc: "John W. Linville" <linville@tuxdriver.com>,
	"Johannes Berg" <johannes@sipsolutions.net>,
	linux-wireless <linux-wireless@vger.kernel.org>
In-Reply-To: <1ba2fa240811181508y633be12pd9f2f9bd0e2c81e4@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
References: <1226915999.3599.33.camel@johannes.berg>
	 <1ba2fa240811170632s49c38320y18da189bf2432d54@mail.gmail.com>
	 <1226933141.3902.19.camel@johannes.berg>
	 <1ba2fa240811170714j7d0daf5xe718ffa1d4de8f40@mail.gmail.com>
	 <1226942887.3902.30.camel@johannes.berg>
	 <1ba2fa240811170934u34fa6e28m1411715690fd24b9@mail.gmail.com>
	 <1226944799.3902.52.camel@johannes.berg>
	 <20081118194652.GD21772@tuxdriver.com>
	 <1ba2fa240811181508y633be12pd9f2f9bd0e2c81e4@mail.gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

some bugs related to coming from resume is filed caused by removing
this callback function, any body looking into alternatives to share
how to fix this problem.

On Tue, Nov 18, 2008 at 3:08 PM, Tomas Winkler <tomasw@gmail.com> wrote:
> On Tue, Nov 18, 2008 at 9:46 PM, John W. Linville
> <linville@tuxdriver.com> wrote:
>> On Mon, Nov 17, 2008 at 06:59:59PM +0100, Johannes Berg wrote:
>>> On Mon, 2008-11-17 at 19:34 +0200, Tomas Winkler wrote:
>>>
>>> > There actually complains about slow reconnection,
>>>
>>> Ok I guess then I haven't seen them for some reason.
>>>
>>> Either way, here's a quick summary:
>>>  * locking issues with the callback are fixed by removing it
>>>  * callback is incorrect when you're only suspended for a very short
>>>    time
>>>  * callback is incorrect when you're in non-STA modes
>>>  * suspend/resume cannot be implemented well through this callback, at
>>>    least not the way it is written now and needs to do a whole lot more
>>>  * there's no "slow" issue when you actually resume in a different
>>>    location where the AP is not around any more
>>>  * there should be no "slow" issue when the AP properly deauthenticates
>>>    when receiving data frames
>>>
>>> This was an RFC. I'm convinced it should go in, but I don't make those
>>> decisions anyway. I've outlined my reasons for it.
>>
>> I agree that it seems to solve problems, and there is little benefit
>> tokeeping the callback in question.  I'm going to send this upstream.
>>
> I suggest to run this code before going upstream
> Tomas
> --
> To unsubscribe from this list: send the line "unsubscribe linux-wireless" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
>
