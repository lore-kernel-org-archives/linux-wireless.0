Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-ob0-f173.google.com ([209.85.214.173]:50564 "EHLO
	mail-ob0-f173.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751528AbaACBH3 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 2 Jan 2014 20:07:29 -0500
Received: by mail-ob0-f173.google.com with SMTP id gq1so15006494obb.4
        for <linux-wireless@vger.kernel.org>; Thu, 02 Jan 2014 17:07:28 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <CA+V6dmh7Udn96GG0XGaabx-t6ZViu1RGk-xTawa_KbnCdro9Ew@mail.gmail.com>
References: <CA+V6dmh7Udn96GG0XGaabx-t6ZViu1RGk-xTawa_KbnCdro9Ew@mail.gmail.com>
From: Pierre Bourdon <delroth@gmail.com>
Date: Fri, 3 Jan 2014 02:07:08 +0100
Message-ID: <CA+V6dmhE4GZhEthU08H+5CvKa0Z98mam4_dG-NEuwK4b5mkhaw@mail.gmail.com> (sfid-20140103_020732_205642_3F36A1D6)
Subject: Re: Exporting the TSF to userland
To: linux-wireless@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Tue, Dec 31, 2013 at 5:24 AM, Pierre Bourdon <delroth@gmail.com> wrote:
> Hello linux-wireless,
>
> I'm a developer of libdrc, a project that allows Linux computers to
> control a Wii U GamePad. Because of how the device operates, our
> library needs to be able to read the TSF value of the access point
> device from userland.
>
> We currently have a hacky patch that works for our use cases, but it
> would be a lot more convenient if that feature could be upstreamed.
> What would be the best way to proceed?
>
> Our current patch:
> https://bitbucket.org/memahaxx/drc-mac80211/commits/4a9823cf2a6733bc15a05cffaebd8850d07451a7

To clarify: I have 0 experience developing "clean" stuff for the Linux
driver (only hacky patches). A few simple questions that I have in
order to make this patch more useful:

* Is there some kind of "threshold" for features like this to be
accepted upstream? How likely is it that this feature will get merged
in the end?

* Is there any framework for exporting data from mac80211 drivers to a
/sys or /proc file? There is code that exports data to debugfs, but
that is usually not mounted by default or enabled by distributions.
Our patch currently uses a /sys file, but I think nothing else in
mac80211 does anything like that so far.

* Should integer values be exported as human-readable ASCII base 10
numbers in proc/sys files or is exporting the raw bytes as our patch
currently does acceptable?

Thanks,

-- 
Pierre "delroth" Bourdon <delroth@gmail.com>
Software Engineer @ Zürich, Switzerland
http://code.delroth.net/
