Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-iy0-f170.google.com ([209.85.210.170]:44066 "EHLO
	mail-iy0-f170.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750956Ab1HMQYP convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sat, 13 Aug 2011 12:24:15 -0400
Received: by iye16 with SMTP id 16so3880364iye.1
        for <linux-wireless@vger.kernel.org>; Sat, 13 Aug 2011 09:24:15 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <4E46A18F.6030508@gmail.com>
References: <4E46A18F.6030508@gmail.com>
Date: Sat, 13 Aug 2011 17:24:15 +0100
Message-ID: <CAH07hy=3Pa9tn2qzAkpAbiPsEL-RjHajZsUUqdSO=ZqYYe+8CQ@mail.gmail.com> (sfid-20110813_182419_559970_9272517B)
Subject: Set Beacon
From: =?ISO-8859-1?Q?Carlos_Guimar=E3es?= <asc2.cemg@gmail.com>
To: linux-wireless@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi,

I'm using NL80211_CMD_SET_BEACON command to set a specific Information
Element to AP Beacon frames. To develop my code I'm using Ubuntu wiht
kernel 2.6.38 and everything works fine. However, when I deploy my
application it does not set the IE to the AP Beacon frames.

The machines I'm using to deploy have kernel 2.6.39-2-686-pae and the
following NIC card:
   *-network:1
        description: Wireless interface
        product: AR922X Wireless Network Adapter
        vendor: Atheros Communications Inc.
        physical id: 4
        bus info: pci@0000:02:04.0
        logical name: ath1
        version: 01
        width: 32 bits
        clock: 66MHz
        capabilities: pm bus_master cap_list ethernet physical wireless
logical
        configuration: broadcast=yes driver=ath9k
driverversion=2.6.39-2-686-pae firmware=N/A ip=192.168.1.2 latency=168
link=yes multicast=yes

I have no more ideias how to fix this problem.

I'm using the next code to do that:
int set_beacon(const char *interface, meta_message_ptr &mih_msg)
{
	struct nl_sock *nl_handle = NULL;
	struct nl_cache *nl_cache = NULL;
	struct genl_family *nl80211 = NULL;
	struct nl_msg *msg;
	mih::frame_vla fm;

	if (connect((void **) &nl_handle,
	            (void **) &nl_cache,
	            (void **) &nl80211) < 0) {
		ODTONE_LOG(1, "Falhei no connect");
		return -1;
	}

	// Create and send message
	if ((msg = nlmsg_alloc()) == NULL) {
		ODTONE_LOG(1, "Falhei no alloc");
		return -1;
	}

	// Set MIH Information Element
	mih_msg->get_frame(fm);
	uint8 *tail = (uint8 *)calloc(fm.get()->length() + 2, sizeof(uint8));
	memset(tail, 51, 1);									// Set Tag
	memset(tail + 1, fm.get()->length(), 1);				// Set Length
	memcpy(tail + 2, fm.get()->get(), fm.get()->length());	// Set Value

	genlmsg_put(msg, 0, 0, genl_family_get_id(nl80211), 0, 0,
NL80211_CMD_SET_BEACON, 0);
	NLA_PUT(msg, NL80211_ATTR_BEACON_TAIL, fm.get()->length() + 2, tail);
	NLA_PUT_U32(msg, NL80211_ATTR_IFINDEX, if_nametoindex(interface));

	if(send_and_receive(nl_handle, msg, NULL, NULL) < 0) {
nla_put_failure:
		nlmsg_free(msg);
		ODTONE_LOG(1, "Falhei no send");
		return -1;
	}

	nlmsg_free(msg);
	ODTONE_LOG(1, "Set beacon");
	return 0;
}

Best regards,
Carlos Guimarães
