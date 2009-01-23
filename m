Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from fk-out-0910.google.com ([209.85.128.190]:2114 "EHLO
	fk-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757564AbZAWW5h (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 23 Jan 2009 17:57:37 -0500
Received: by fk-out-0910.google.com with SMTP id f33so1459700fkf.5
        for <linux-wireless@vger.kernel.org>; Fri, 23 Jan 2009 14:57:35 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <1232749288.3977.14.camel@johannes.local>
References: <49788E88.5000608@telecom-sudparis.eu>
	 <1232749288.3977.14.camel@johannes.local>
Date: Fri, 23 Jan 2009 14:57:35 -0800
Message-ID: <45e8e6c40901231457x57625153wad49b4869a1627bd@mail.gmail.com> (sfid-20090123_235740_064589_DB179748)
Subject: Re: SIOCSIFFLAGS: Name not unique on network
From: Andrey Yurovsky <andrey@cozybit.com>
To: Johannes Berg <johannes@sipsolutions.net>
Cc: Chanthearith HUON <chanthearith.huon@telecom-sudparis.eu>,
	linux-wireless@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Fri, Jan 23, 2009 at 2:21 PM, Johannes Berg
<johannes@sipsolutions.net> wrote:
> On Thu, 2009-01-22 at 16:19 +0100, Chanthearith HUON wrote:
>
>> This wireless card is not listed
>> in http://linuxwireless.org/en/users/Devices
>> <http://linuxwireless.org/en/users/Devices>
>> but the driver is in the
>> list http://linuxwireless.org/en/developers/Documentation/mac80211#mac80211drivers
>> <http://linuxwireless.org/en/developers/Documentation/mac80211#mac80211drivers>
>
> But it's listed here:
> http://linuxwireless.org/en/users/Drivers
>
> -- as not supporting mesh.
>
>> The OS is ubuntu Intrepid Ibex 8.10 with kernel 2.6.27-9-generic
>>
>> After creating new interface for mesh "iw dev wlan0 interface add mesh
>> type mp mesh_id 100". I turned the mesh interface up by "ifconfig mesh up".
>> I got following error message
>> " SIOCSIFFLAGS: Name not unique on network "
>
> That's strange, it should not have allowed you to add the interface in
> the first place. But then, you're using an ancient kernel anyway...
>
> johannes
>

That's indeed strange: the iwl3945 (along with the other Intel cards)
definitely doesn't support mesh but I was able to add an interface as
well on my Ubuntu box (2.6.27-9).  I think the reason is that iwlwifi
doesn't explicitly test for interfaces it actually supports:

static int iwl3945_mac_add_interface(struct ieee80211_hw *hw,
                                 struct ieee80211_if_init_conf *conf)
{
        struct iwl_priv *priv = hw->priv;
        unsigned long flags;

        IWL_DEBUG_MAC80211("enter: type %d\n", conf->type);

        if (priv->vif) {
                IWL_DEBUG_MAC80211("leave - vif != NULL\n");
                return -EOPNOTSUPP;
        }
<snip>
