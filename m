Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-it0-f67.google.com ([209.85.214.67]:38611 "EHLO
        mail-it0-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1753264AbeGEJ5g (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Thu, 5 Jul 2018 05:57:36 -0400
Received: by mail-it0-f67.google.com with SMTP id v71-v6so994713itb.3
        for <linux-wireless@vger.kernel.org>; Thu, 05 Jul 2018 02:57:35 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <20180705093230.byqbk6f5ornezmka@mwanda>
References: <CAPpJ_ed1oFQW_xmBtetP-ztoL7Z14T6akOSgKJ_8jxogdf3FWg@mail.gmail.com>
 <f3bf0687-76fb-9411-6fa2-e8ef312efb58@lwfinger.net> <20180704140933.3dk2ylbntltz6jqd@mwanda>
 <7e95bd6a-97bc-b030-26ce-83da66e5f279@lwfinger.net> <CAD8Lp44EG73XQ9omQhH6XiHfm2rMypmndSFyffnf_PVMueTvEA@mail.gmail.com>
 <1530776154.4156.12.camel@realtek.com> <CAPpJ_ecCzhxEu8gMBFRsCerpeu_Z8TR=Rw5BiFhzVYP6WK-wAw@mail.gmail.com>
 <20180705093230.byqbk6f5ornezmka@mwanda>
From: Jian-Hong Pan <jian-hong@endlessm.com>
Date: Thu, 5 Jul 2018 17:57:34 +0800
Message-ID: <CAPpJ_ef8At7dWZwByPYvOX56930LXtXRFLpkxjmb_+jVGLLb5w@mail.gmail.com> (sfid-20180705_115758_341732_CADF861B)
Subject: Re: [BUG] staging: r8822be: RTL8822be can't find any wireless AP
To: Dan Carpenter <dan.carpenter@oracle.com>
Cc: Pkshih <pkshih@realtek.com>,
        "devel@driverdev.osuosl.org" <devel@driverdev.osuosl.org>,
        Tony Chuang <yhchuang@realtek.com>,
        "arnd@arndb.de" <arnd@arndb.de>,
        Steven Ting <steventing@realtek.com>,
        "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Birming Chiu <birming@realtek.com>,
        "drake@endlessm.com" <drake@endlessm.com>,
        "sgruszka@redhat.com" <sgruszka@redhat.com>,
        "kvalo@codeaurora.org" <kvalo@codeaurora.org>,
        "gregkh@linuxfoundation.org" <gregkh@linuxfoundation.org>,
        "frank@generalsoftwareinc.com" <frank@generalsoftwareinc.com>,
        "colin.king@canonical.com" <colin.king@canonical.com>,
        "linux@endlessm.com" <linux@endlessm.com>,
        "Larry.Finger@lwfinger.net" <Larry.Finger@lwfinger.net>
Content-Type: text/plain; charset="UTF-8"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

2018-07-05 17:32 GMT+08:00 Dan Carpenter <dan.carpenter@oracle.com>:
> On Thu, Jul 05, 2018 at 05:26:28PM +0800, Jian-Hong Pan wrote:
>> 2018-07-05 15:36 GMT+08:00 Pkshih <pkshih@realtek.com>:
>> > On Wed, 2018-07-04 at 10:33 -0500, Daniel Drake wrote:
>> >> On Wed, Jul 4, 2018 at 10:13 AM, Larry Finger <Larry.Finger@lwfinger.net> wrote:
>> >> > We will have to agree to disagree.
>> >> >
>> >> > I have no idea what the vendors are doing that cause some motherboards to
>> >> > need a different aspm value. What I do know is that we have had to live with
>> >> > the idiocy of some vendors saving a few pennies by only including a single
>> >> > antenna, rather than two, and then making a problem by miscoding the EFUSE
>> >> > bit that indicates which connector is actually in use. As we have no means
>> >> > that I know about to detect which boxes have the problem, a module parameter
>> >> > was created, just as in this case.
>> >> >
>> >> > I agree that drivers should work "out of the box", but finite resources and
>> >> > lack of vendor cooperation make this a goal that may not be attainable.
>> >>
>> >> As you touched on, the ideal situation is that Realtek solve the
>> >> issue. Ping-Ke Shih is on CC and I am adding a few more contacts from
>> >> the commit log. The context is that the r8822 driver fails on several
>> >> platforms unless setting aspm=0 (the default is 1).
>> >
>> > It's hard to have all laptop or motherboards and all rtl8822be modules in my side,
>> > so what I can do is to analyze the issue when user encountered.
>> >
>> >>
>> >> https://gist.github.com/dsd/20c05f0c6d66ee2ef9bfbb17f93f18ba
>> >> https://bugzilla.kernel.org/show_bug.cgi?id=199651
>> >>
>> >>
>> >> If we don't get a timely fix from Realtek though, I think there is a
>> >> key difference between the antenna selection headache and this one. In
>> >> the antenna case, there isn't a good value that you can set that will
>> >> work on all systems. If you change the default behaviour you will
>> >> solve the issue for some users while simultanously introducing the
>> >> problem on other systems that were previously fine.
>> >>
>> >> However in this case, it's highly likely that setting aspm=0 (off) by
>> >> default would work for everyone. It has the disadvantage of using a
>> >> bit more power, but especially with the indications that this issue
>> >> affects a significant number of systems, I think that having the
>> >> driver working out of the box everywhere is more important. The module
>> >> parameter can be left in place so that unaffected users that want to
>> >> save power can set aspm=1.
>> >>
>> >
>> > I think this issue may be due to L1 latency, so below patch would be
>> > helpful but not sure because I don't have the same laptop.
>> > Is there anyone can help to test?
>>
>> I do not know why I cannot apply this patch directly.  So, I apply
>> each line manually.
>>
>> However, here is a good news.  I tested this fix, and it works
>> correctly on ASUS X530UN.  System can scan and get the access points
>> list.  Finally, it also connects to the access point.
>> Maybe, you can have a formal patch for this.
>>
>
> That's good news.  What does the "dmesg | grep r8822be" say now?

dev@endless:~/linux-eos$ dmesg | grep r8822be
[    8.538404] r8822be: module is from the staging directory, the
quality is unknown, you have been warned.
[    8.541706] r8822be 0000:02:00.0: enabling device (0000 -> 0003)
[    8.571568] r8822be: Using firmware rtlwifi/rtl8822befw.bin
[    8.572370] r8822be: rtlwifi: wireless switch is on
[    8.573338] r8822be 0000:02:00.0 wlp2s0: renamed from wlan0
[   11.346560] Modules linked in: nouveau(+) snd_hda_codec_hdmi
snd_hda_codec_realtek snd_hda_codec_generic snd_hda_intel mxm_wmi
snd_hda_codec r8822be(C) x86_pkg_temp_thermal snd_hwdep snd_hda_core
efivarfs i915

The warning message comes from nouveau.  That is no matter.

Here is the full dmesg
https://gist.github.com/starnight/29b1ead5659868fcfb7f172e51a96535#file-gistfile1-txt

Regards,
Jian-Hong Pan
