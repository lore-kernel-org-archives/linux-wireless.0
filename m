Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-yw0-f46.google.com ([209.85.213.46]:64860 "EHLO
	mail-yw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755771Ab2GXRvU (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 24 Jul 2012 13:51:20 -0400
Received: by yhmm54 with SMTP id m54so6949204yhm.19
        for <linux-wireless@vger.kernel.org>; Tue, 24 Jul 2012 10:51:20 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <CAG-2HqV4w5eRdh7SzdiXe+LUWpD=jHH1C7sk4G-LiTwdLJbgwg@mail.gmail.com>
References: <CAPXgP11iT9K2KcDCJvw_druf5qdNjs0jLfrbpS7CcYh5vXrz_w@mail.gmail.com>
 <1326621743.3448.1.camel@jlt3.sipsolutions.net> <CAPXgP13b0uu3DgOGRL-_WKx-aSQN-f0xL6OmjNPBGf9fg0satA@mail.gmail.com>
 <1326704259.3510.3.camel@jlt3.sipsolutions.net> <CAPXgP12gM3_OVuxQAkRRarH_TpjVpbh5NpcTPWL0nEi4eoX+kw@mail.gmail.com>
 <1326716209.3510.7.camel@jlt3.sipsolutions.net> <CAPXgP13xJNx0v9waZx6m47Ye7q71GGz3A3DoQzb=qszHnOkArw@mail.gmail.com>
 <1343139390.4415.31.camel@jlt3.sipsolutions.net> <CAG-2HqV4w5eRdh7SzdiXe+LUWpD=jHH1C7sk4G-LiTwdLJbgwg@mail.gmail.com>
From: Kay Sievers <kay@vrfy.org>
Date: Tue, 24 Jul 2012 19:50:59 +0200
Message-ID: <CAPXgP10idwzJgtFW3v=wMnrqfy8+rte3xotkRqRHjssdTT1zyw@mail.gmail.com> (sfid-20120724_195125_012086_37A8BF12)
Subject: Re: calling request_firmware() from module init will not work with
 recent/future udev versions
To: Tom Gundersen <teg@jklm.no>
Cc: Johannes Berg <johannes@sipsolutions.net>, netdev@vger.kernel.org,
	linux-wireless@vger.kernel.org, Andy Whitcroft <apw@canonical.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Tue, Jul 24, 2012 at 4:32 PM, Tom Gundersen <teg@jklm.no> wrote:
> On Tue, Jul 24, 2012 at 4:16 PM, Johannes Berg
> <johannes@sipsolutions.net> wrote:
>>> The logic to tell udev that it runs in the initramfs could easily be
>>> implemented by other initramfs tools than dracut, but they usually do
>>> not really follow what we do here, so this might for now only work on
>>> recent systems using dracut.
>>
>> Ok, too bad there wasn't a generic way, but at least there's a way
>> now :-)
>
> If I understand the code correctly, it should be enough to put a file
> /etc/initrd-release in the initramfs for udev to do the right thing.
> But please correct me if I'm wrong Kay.

The current check in udev/systemd is the existence of:
  /etc/initrd-release
and the / filesystem must be tmpfs/ramfs to get the environment
recognized as 'initrd'.

Kay
