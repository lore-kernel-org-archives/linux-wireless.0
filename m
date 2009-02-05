Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from yx-out-2324.google.com ([74.125.44.29]:46047 "EHLO
	yx-out-2324.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752400AbZBEPg6 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 5 Feb 2009 10:36:58 -0500
Received: by yx-out-2324.google.com with SMTP id 8so114331yxm.1
        for <linux-wireless@vger.kernel.org>; Thu, 05 Feb 2009 07:36:56 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <1233845863.3028.9.camel@localhost>
References: <20090204150857.GA5069@sortiz.org>
	 <1233789837.24227.19.camel@localhost.localdomain>
	 <1233790539.7390.23.camel@johannes.local>
	 <20090205084407.GA11126@jm.kir.nu> <20090205095217.GA13736@jm.kir.nu>
	 <1ba2fa240902050344h1deb4c3dqce0949ec154faba4@mail.gmail.com>
	 <20090205121222.GB18339@jm.kir.nu>
	 <1ba2fa240902050500p6d8e01d3k6b934f904bd41395@mail.gmail.com>
	 <1233845863.3028.9.camel@localhost>
Date: Thu, 5 Feb 2009 17:36:56 +0200
Message-ID: <1ba2fa240902050736x109d6424y78644645f285799@mail.gmail.com> (sfid-20090205_163702_419694_3CB25CEF)
Subject: Re: [PATCH RFC] mac80211: Filter scan results
From: Tomas Winkler <tomasw@gmail.com>
To: Dan Williams <dcbw@redhat.com>
Cc: Jouni Malinen <j@w1.fi>, Johannes Berg <johannes@sipsolutions.net>,
	Samuel Ortiz <samuel@sortiz.org>,
	John Linville <linville@tuxdriver.com>,
	Reinette Chatre <reinette.chatre@intel.com>,
	linux-wireless@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Thu, Feb 5, 2009 at 4:57 PM, Dan Williams <dcbw@redhat.com> wrote:
> On Thu, 2009-02-05 at 15:00 +0200, Tomas Winkler wrote:
>> On Thu, Feb 5, 2009 at 2:12 PM, Jouni Malinen <j@w1.fi> wrote:
>> > On Thu, Feb 05, 2009 at 01:44:15PM +0200, Tomas Winkler wrote:
>> >
>> >> Just a thought If user space will be able to merge 2 scan results we
>> >> can then split then in 2 separate reports....
>> >
>> > Theoretically speaking, yes, WEXT could be extended to do this with some
>> > kind of scan parameter that indicates which 64 kB block is requested.
>> > However, I would not suggest going there and I would probably object to
>> > a patch that tries to do this either in the kernel or in wpa_supplicant
>> > for that matter.
>>
>> I thin it can be done w/o extension of  wext, j ust the eviction of
>> old scan results is done
>> in user space.IRCC the time stamp of beacon/probe is part of each
>> entry. And user space state machine should be able to react on
>> nl[SIOCGIWSCAN] w/o issuing ioctl[SIOCSIWSCAN]:
>
> I still don't like this.  If 177 BSSes is not enough, then get the
> cfg80211 stuff working better for you.  I can't think of how this scheme
> would work; which half of the results get returned when something calls
> SIOCGIWSCAN?  Would the driver/stack internally flip to the other half
> of the results on each call of SIOCGIWSCAN?  That doesn't work, because
> then two userspace processes requesting scan results will race with each
> other for them.  We had this problem before when drivers cleared the
> scan list each time SIOCGIWSCAN was called.

Good point. A simple token will resolve this problem but this is again
changing wext which I wanted to avoid...no free lunch (
Anyhow I know it's possible but  is this a common usecase that two
application request scan?

Thanks
Tomas
