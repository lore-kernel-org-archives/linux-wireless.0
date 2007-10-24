Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from an-out-0708.google.com ([209.85.132.245]:36005 "EHLO
	an-out-0708.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754949AbXJXRZM (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 24 Oct 2007 13:25:12 -0400
Received: by an-out-0708.google.com with SMTP id b36so46366ana
        for <linux-wireless@vger.kernel.org>; Wed, 24 Oct 2007 10:25:11 -0700 (PDT)
Message-ID: <43e72e890710241025g3491310fgfcc380cb04280a56@mail.gmail.com> (sfid-20071024_182521_648839_0C0C50A3)
Date: Wed, 24 Oct 2007 13:25:10 -0400
From: "Luis R. Rodriguez" <mcgrof@gmail.com>
To: "Dan Williams" <dcbw@redhat.com>
Subject: Re: Proc usage (was: Re: [ath5k-devel] [PATCH 3/3] consistently use ath5k in printks)
Cc: "Eric W Anderson" <Eric.Anderson@colorado.edu>,
	"Nick Kossifidis" <mickflemm@gmail.com>,
	"Johannes Berg" <johannes@sipsolutions.net>,
	ath5k-devel@lists.ath5k.org, linux-wireless@vger.kernel.org,
	"John Linville" <linville@tuxdriver.com>,
	"Greg KH" <greg@kroah.com>, "Thomas Graf" <tgraf@suug.ch>
In-Reply-To: <1193238601.2557.43.camel@localhost.localdomain>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
References: <1192540838-26985-1-git-send-email-bruno@thinktube.com>
	 <1192540838-26985-2-git-send-email-bruno@thinktube.com>
	 <1192540838-26985-3-git-send-email-bruno@thinktube.com>
	 <1192540838-26985-4-git-send-email-bruno@thinktube.com>
	 <1192619652.8841.13.camel@johannes.berg>
	 <1192630172.10567.29.camel@localhost.localdomain>
	 <43e72e890710170719o120f9dbak34f33d8218038dfc@mail.gmail.com>
	 <40f31dec0710170926p3847b796gdf52f80297b7c117@mail.gmail.com>
	 <471EC944.2010700@colorado.edu>
	 <1193238601.2557.43.camel@localhost.localdomain>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 10/24/07, Dan Williams <dcbw@redhat.com> wrote:
> On Tue, 2007-10-23 at 22:25 -0600, Eric W Anderson wrote:
> > I realize that primary role of the driver is for actual use, rather than for
> > research, but...  It's very useful in experiments to have /proc entries for all
> > the settings that you don't normally think of as tunable.  (e.g. turning off
> > antenna diversity, or ACKs, or changing the CCA thresholds). I'd really hate for
> > knobs to go away because someone things they're not "really" needed, or because
> > they're not worth merging into the new configuration framework.
>
> debugfs is one answer here.

As it stands debugfs does provide a wide range of useful information.

Here's the info for my phy0:
mcgrof@pogo:~$ ls /debug/ieee80211/phy0/
antenna_sel_rx           frequency         netdev:wlan3       statistics
antenna_sel_tx           keys              netdev:wmaster0    total_ps_buffered
bridge_packets           long_retry_limit  rts_threshold      wep_iv
channel                  mode              short_retry_limit
fragmentation_threshold  modes             stations


Here's statistics:

mcgrof@pogo:~$ ls /debug/ieee80211/phy0/statistics/
dot11ACKFailureCount               rx_handlers_fragments
dot11FCSErrorCount                 rx_handlers_queued
dot11RTSFailureCount               transmitted_fragment_count
dot11RTSSuccessCount               transmitted_frame_count
failed_count                       tx_expand_skb_head
frame_duplicate_count              tx_expand_skb_head_cloned
multicast_received_frame_count     tx_handlers_drop
multicast_transmitted_frame_count  tx_handlers_drop_fragment
multiple_retry_count               tx_handlers_drop_not_assoc
received_fragment_count            tx_handlers_drop_unauth_port
retry_count                        tx_handlers_drop_unencrypted
rx_expand_skb_head                 tx_handlers_drop_wep
rx_expand_skb_head2                tx_handlers_queued
rx_handlers_drop                   tx_status_drop
rx_handlers_drop_defrag            wep_undecryptable_count
rx_handlers_drop_nullfunc          wme_rx_queue
rx_handlers_drop_passive_scan      wme_tx_queue
rx_handlers_drop_short

For wlan3:

mcgrof@pogo:~$ ls /debug/ieee80211/phy0/netdev\:wlan3/
aid          auth_algs         capab             extra_ie_len  ssid_len
ap_capab     auth_transaction  channel_use       flags         state
assoc_tries  auth_tries        drop_unencrypted  ieee8021_x
auth_alg     bssid             eapol             prev_bssid

For wmaser0:

mcgrof@pogo:~$ ls /debug/ieee80211/phy0/netdev\:wmaster0/
beacon_head_len   dtim_count             ieee8021_x              num_sta_ps
beacon_tail_len   dtim_period            max_ratectrl_rateidx
channel_use       eapol                  num_beacons
drop_unencrypted  force_unicast_rateidx  num_buffered_multicast


> The point is to make it 110% crystal clear
> what options are long-term supportable as API/ABI and which ones are
> not.

IMHO a lot of this is very useful information and as such probably
shouldn't be exported as part of debugfs but instead be accessible via
sysfs or configfs which can later be relied upon in the long term. The
fine line between whether statistics should go sysfs or configfs is
vague to me.

As for configuration it was decided a while ago we'd use netlink so
AFAICT we're sticking to that. This doesn't mean we can't provide
alternatives for accessing information. My intentions was to start a
configfs module for the new linux wireless subsystem (cfg80211
devices), which I have already but used only for changing regulatory
domain, where we can add things onto a filesystem for configuration.
The add/remove interface stuff was also pulled from sysfs and now is
available only through nl80211, the idea was to later add the
filesystem approach to configfs. Currently you can use the add/remove
interface with the new iw utility though:

http://git.sipsolutions.net/iw.git/

This requires libnl-HEAD though as we use genl. I hope there's a
release soon of libnl so distributions can pick up genl support.

The idea with configfs is not to replace nl80211 but to simply provide
an alternative. I believe this would be the right place to put any of
these easy tunable values through a filesystem, which experimenters
just love to use.

Ironing all this will take some time. These types of discussions will
help us in the end.

  Luis
