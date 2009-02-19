Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-gx0-f174.google.com ([209.85.217.174]:34083 "EHLO
	mail-gx0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751078AbZBSORJ (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 19 Feb 2009 09:17:09 -0500
Received: by gxk22 with SMTP id 22so1024272gxk.13
        for <linux-wireless@vger.kernel.org>; Thu, 19 Feb 2009 06:17:06 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <20090218080636.GA25504@toronto053.server4you.de>
References: <20090216160016.GA29509@toronto053.server4you.de>
	 <1234800284.4219.136.camel@johannes.local>
	 <20090216172528.GB29509@toronto053.server4you.de>
	 <1234807251.1666.9.camel@localhost.localdomain>
	 <20090218080636.GA25504@toronto053.server4you.de>
Date: Thu, 19 Feb 2009 16:17:06 +0200
Message-ID: <55c333c0902190617w7ced9b7cu45ab0aad44305c77@mail.gmail.com> (sfid-20090219_151716_189808_5E828146)
Subject: Re: NetworkManager and mac80211_hwsim
From: Kevin Wilson <wkevils@gmail.com>
To: Daniel Wagner <wagi@monom.org>
Cc: Dan Williams <dcbw@redhat.com>,
	Johannes Berg <johannes@sipsolutions.net>,
	linux-wireless@vger.kernel.org, networkmanager-list@gnome.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hello,

Can you please tell against which version of hal source you
made this patch ? I tried it against the hal sources in my
fedora distro and got errors when patching.
Rgs,
Kevin


On Wed, Feb 18, 2009 at 10:06 AM, Daniel Wagner <wagi@monom.org> wrote:
> On Mon, Feb 16, 2009 at 01:00:51PM -0500, Dan Williams wrote:
>> On Mon, 2009-02-16 at 18:25 +0100, Daniel Wagner wrote:
>> > On Mon, Feb 16, 2009 at 05:04:44PM +0100, Johannes Berg wrote:
>> > > On Mon, 2009-02-16 at 17:00 +0100, Daniel Wagner wrote:
>> > >
>> > > > hotplug_event_begin_add_dev (..., parent_dev = NULL, ...)
>> > > >   net_add(..., parent_dev = NULL, ...)
>> > > >   {
>> > > >         if (parent_dev == NULL)
>> > > >                 goto error;
>> > > >   }
>> > > >
>> > > > Before I go deeper into that thing, does someone has
>> > > > an idea what could go wrong here with mac80211_hwsim?
>> > >
>> > > hwsim phys have no parents in sysfs since they're virtual.
>> >
>> > Do you propose to patch hald to handle this situation then?
>>
>> The patch (for now) would have to go in hal, since obviously if HAL
>> can't see it, NM won't.  Until we port over to DeviceKit of course.
>
> Thanks for the information. After looking at HAL for a while and
> knowing that it will be replaced in the near future I decided
> not to write a proper patch. Instead I came up with a big hack.
> With this hack NM sees the mac80211_hwsim devices :)
>
> daniel
>
> ---
>  hald/linux/device.c |   23 +++++++++++++----------
>  1 files changed, 13 insertions(+), 10 deletions(-)
>
> diff --git a/hald/linux/device.c b/hald/linux/device.c
> index e48548e..699d26b 100644
> --- a/hald/linux/device.c
> +++ b/hald/linux/device.c
> @@ -497,20 +497,22 @@ net_add (const gchar *sysfs_path, const gchar *device_file, HalDevice *parent_de
>        guint media_type;
>        gint flags;
>
> -       d = NULL;
> -
> -       if (parent_dev == NULL)
> -               goto error;
> -
>        d = hal_device_new ();
>        hal_device_property_set_string (d, "linux.sysfs_path", sysfs_path);
> -       hal_device_property_set_string (d, "info.parent", hal_device_get_udi (parent_dev));
> +       if (parent_dev != NULL) {
> +               hal_device_property_set_string (d, "info.parent", hal_device_get_udi (parent_dev));
> +               hal_device_property_set_string (d, "net.originating_device", hal_device_get_udi (parent_dev));
> +       } else {
> +               hal_device_property_set_string (d, "info.parent", "/org/freedesktop/Hal/devices/computer");
> +               hal_device_property_set_string (d, "net.originating_device", "/org/freedesktop/Hal/devices/computer");
> +               hal_device_property_set_string (d, "info.linux.driver", "mac80211_hwsim");
> +               parent_dev = hal_device_store_find (hald_get_gdl (), "/org/freedesktop/Hal/devices/computer");
> +               hal_device_property_set_string (parent_dev, "info.linux.driver", "mac80211");
> +       }
>
>        hal_device_property_set_string (d, "info.category", "net");
>        hal_device_add_capability (d, "net");
>
> -       hal_device_property_set_string (d, "net.originating_device", hal_device_get_udi (parent_dev));
> -
>        ifname = hal_util_get_last_element (sysfs_path);
>        hal_device_property_set_string (d, "net.interface", ifname);
>
> @@ -530,7 +532,7 @@ net_add (const gchar *sysfs_path, const gchar *device_file, HalDevice *parent_de
>        media_type = hal_device_property_get_int (d, "net.arp_proto_hw_id");
>        if (media_type == ARPHRD_ETHER) {
>                const char *addr;
> -               const char *parent_subsys;
> +               const char *parent_subsys = 0;
>                char bridge_path[HAL_PATH_MAX];
>                char wireless_path[HAL_PATH_MAX];
>                char wiphy_path[HAL_PATH_MAX];
> @@ -557,7 +559,8 @@ net_add (const gchar *sysfs_path, const gchar *device_file, HalDevice *parent_de
>                snprintf (wireless_path, HAL_PATH_MAX, "%s/wireless", sysfs_path);
>                /* wireless dscape stack e.g. from rt2500pci driver*/
>                snprintf (wiphy_path, HAL_PATH_MAX, "%s/wiphy", sysfs_path);
> -               parent_subsys = hal_device_property_get_string (parent_dev, "info.subsystem");
> +               if (parent_dev)
> +                       parent_subsys = hal_device_property_get_string (parent_dev, "info.subsystem");
>
>                if (parent_subsys && strcmp(parent_subsys, "bluetooth") == 0) {
>                        hal_device_property_set_string (d, "info.product", "Bluetooth Interface");
> --
> 1.6.0.2.GIT
>
> --
> To unsubscribe from this list: send the line "unsubscribe linux-wireless" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
>
