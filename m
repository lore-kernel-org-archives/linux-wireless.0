Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-we0-f174.google.com ([74.125.82.174]:49601 "EHLO
	mail-we0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754978Ab2GXOcx (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 24 Jul 2012 10:32:53 -0400
Received: by weyx8 with SMTP id x8so5117937wey.19
        for <linux-wireless@vger.kernel.org>; Tue, 24 Jul 2012 07:32:51 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <1343139390.4415.31.camel@jlt3.sipsolutions.net>
References: <CAPXgP11iT9K2KcDCJvw_druf5qdNjs0jLfrbpS7CcYh5vXrz_w@mail.gmail.com>
 <1326621743.3448.1.camel@jlt3.sipsolutions.net> <CAPXgP13b0uu3DgOGRL-_WKx-aSQN-f0xL6OmjNPBGf9fg0satA@mail.gmail.com>
 <1326704259.3510.3.camel@jlt3.sipsolutions.net> <CAPXgP12gM3_OVuxQAkRRarH_TpjVpbh5NpcTPWL0nEi4eoX+kw@mail.gmail.com>
 <1326716209.3510.7.camel@jlt3.sipsolutions.net> <CAPXgP13xJNx0v9waZx6m47Ye7q71GGz3A3DoQzb=qszHnOkArw@mail.gmail.com>
 <1343139390.4415.31.camel@jlt3.sipsolutions.net>
From: Tom Gundersen <teg@jklm.no>
Date: Tue, 24 Jul 2012 16:32:31 +0200
Message-ID: <CAG-2HqV4w5eRdh7SzdiXe+LUWpD=jHH1C7sk4G-LiTwdLJbgwg@mail.gmail.com> (sfid-20120724_163310_864340_56BDF5C6)
Subject: Re: calling request_firmware() from module init will not work with
 recent/future udev versions
To: Johannes Berg <johannes@sipsolutions.net>
Cc: Kay Sievers <kay@vrfy.org>, netdev@vger.kernel.org,
	linux-wireless@vger.kernel.org, Andy Whitcroft <apw@canonical.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Tue, Jul 24, 2012 at 4:16 PM, Johannes Berg
<johannes@sipsolutions.net> wrote:
>> The logic to tell udev that it runs in the initramfs could easily be
>> implemented by other initramfs tools than dracut, but they usually do
>> not really follow what we do here, so this might for now only work on
>> recent systems using dracut.
>
> Ok, too bad there wasn't a generic way, but at least there's a way
> now :-)

If I understand the code correctly, it should be enough to put a file
/etc/initrd-release in the initramfs for udev to do the right thing.
But please correct me if I'm wrong Kay.

-t
