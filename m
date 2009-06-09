Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mailgw1.uni-kl.de ([131.246.120.220]:37645 "EHLO
	mailgw1.uni-kl.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753321AbZFIXuP (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 9 Jun 2009 19:50:15 -0400
Message-ID: <4A2EEA07.1050306@informatik.uni-kl.de>
Date: Wed, 10 Jun 2009 01:02:31 +0200
From: Reiner Herrmann <r_herrma@informatik.uni-kl.de>
MIME-Version: 1.0
To: linux-wireless@vger.kernel.org, kernelnewbies@nl.linux.org
CC: m_wilhel@informatik.uni-kl.de
Subject: Sending netlink messages in mac80211 tx handler
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi,

I want to register a TX handler for mac80211 and send a (generic)
netlink message in it. But everytime the handler gets invoked and
the message sent, the kernel crashes.


A minimal version of the TX handler looks like that:


static ieee80211_tx_result debug_noinline
ieee80211_tx_h_test(struct ieee80211_tx_data *tx)
{
        struct sk_buff* skb = genlmsg_new(NLMSG_GOODSIZE, GFP_KERNEL);
        void* hdr;

        if(!skb)
                goto out;

        hdr = genlmsg_put(skb, 0, 0, &nl80211_fam, 0, NL80211_CMD_DISCOSEC);
        if(IS_ERR(hdr))
                goto free_skb;

        nla_put_u32(skb, NL80211_ATTR_DISCOSEC_HELO, 42);
        genlmsg_end(skb, hdr);
        genlmsg_unicast(skb, get_daemon_pid());

free_skb:
        nlmsg_free(skb);
out:
        return TX_CONTINUE;
}


( and CALL_TXH(ieee80211_tx_h_test) in invoke_tx_handlers() )









The userspace daemon looks like that:








#include <netlink/netlink.h>


#include <netlink/genl/genl.h>


#include "../../linux/include/linux/nl80211.h"





const char* interface = "wlan0";


struct nl_handle *sock = NULL;


int family_id = 0;


struct genl_family* family = NULL;


struct nl_cache* cache = NULL;


struct nl_cb* cb = NULL;





int nl_callback(struct nl_msg* msg, void* arg)


{


        struct nlmsghdr* nlh = nlmsg_hdr(msg);


        struct nlattr* attrs[NL80211_ATTR_MAX+1];


        genlmsg_parse(nlh, 0, attrs, NL80211_ATTR_MAX, NULL);



        if(attrs[NL80211_ATTR_DISCOSEC_HELO])
        {
                printf("Kernel sent HELO!\n");
                struct nl_msg* msg = nlmsg_alloc();
                genlmsg_put(msg, NL_AUTO_PID, NL_AUTO_SEQ, family_id, 0,
0, NL80211_CMD_DISCOSEC, 1);
                nla_put_u32(msg, NL80211_ATTR_IFINDEX,
if_nametoindex(interface));
                nl_send_auto_complete(sock, msg);

                nlmsg_free(msg);

        }


        return NL_OK;
}

void register_at_kernel()
{
        struct nl_msg* msg = nlmsg_alloc();
        genlmsg_put(msg, NL_AUTO_PID, NL_AUTO_SEQ, family_id, 0, 0,
NL80211_CMD_DISCOSEC, 1);
        nla_put_u32(msg, NL80211_ATTR_IFINDEX,
if_nametoindex(interface));
        nla_put_u8(msg, NL80211_ATTR_DISCOSEC_HELO, 42);

        nl_send_auto_complete(sock, msg);

        nlmsg_free(msg);

}


int init()
{
        cb = nl_cb_alloc(NL_CB_VERBOSE);
        nl_cb_set(cb, NL_CB_VALID, NL_CB_CUSTOM, nl_callback, "VALID");
        nl_cb_set(cb, NL_CB_INVALID, NL_CB_CUSTOM, nl_callback, "INVALID");

        sock = nl_handle_alloc_cb(cb);
        genl_connect(sock);
        family_id = genl_ctrl_resolve(sock, "nl80211");
        register_at_kernel();

        return 0;
}

int main(int argc, char* argv[])
{
        init();

        while(1)
        {
                nl_recvmsgs_default(sock);
                //usleep(500000);
        }

        return 0;
}



After loading mac80211 the daemon registers its pid at the kernel
(which is working fine). When I then start hostapd and the TX handler
is called, I get the following crash:



[  129.378528] BUG: unable to handle kernel NULL pointer dereference at
(null)
[  129.378716] IP: [<c03aa18e>] __skb_recv_datagram+0xbe/0x210

[  129.378859] *pde = 00000000

[  129.378982] Oops: 0002 [#1] SMP

[  129.379158] last sysfs file: /sys/devices/virtual/net/lo/operstate

[  129.379242] Modules linked in: mac80211_hwsim mac80211 cfg80211
netconsole
[  129.379574]

[  129.379648] Pid: 1974, comm: test Not tainted (2.6.30-rc6 #29) 1000HE

[  129.379734] EIP: 0060:[<c03aa18e>] EFLAGS: 00010046 CPU: 0

[  129.379819] EIP is at __skb_recv_datagram+0xbe/0x210

[  129.379900] EAX: 00000000 EBX: f72c0d40 ECX: 00000246 EDX: 00000000

[  129.379984] ESI: f14ed400 EDI: f14ed470 EBP: f7215d18 ESP: f7215ce4

[  129.380047]  DS: 007b ES: 007b FS: 00d8 GS: 0033 SS: 0068

[  129.380047] Process test (pid: 1974, ti=f7214000 task=f7b8c810
task.ti=f7214000)
[  129.380047] Stack:

[  129.380047]  f14ed4cc f7215d24 00000000 f14ed47c 7fffffff 00000001
f7b8c810 c03aa310
[  129.380047]  f7215d04 f7215d04 f7215d6c 00000000 f7215f38 f7215d2c
c03aa303 f7215d6c
[  129.380047]  00000000 c047e4e0 f7215d7c c03c7787 f7215d6c 000007b6
f14ed400 f7215d54
[  129.380047] Call Trace:

[  129.380047]  [<c03aa310>] ? receiver_wake_function+0x0/0x40

[  129.380047]  [<c03aa303>] ? skb_recv_datagram+0x23/0x30

[  129.380047]  [<c03c7787>] ? netlink_recvmsg+0x57/0x2e0

[  129.380047]  [<c03a0f44>] ? sock_recvmsg+0xd4/0x100

[  129.380047]  [<c0141300>] ? autoremove_wake_function+0x0/0x50

[  129.380047]  [<c01b005a>] ? d_rehash+0x2a/0x40

[  129.380047]  [<c025b311>] ? copy_from_user+0x31/0x80

[  129.380047]  [<c03a9c70>] ? verify_iovec+0x30/0xb0

[  129.380047]  [<c025b2a2>] ? copy_to_user+0x32/0x70

[  129.380047]  [<c025b311>] ? copy_from_user+0x31/0x80

[  129.380047]  [<c03a9c70>] ? verify_iovec+0x30/0xb0

[  129.380047]  [<c03a1d94>] ? sys_recvmsg+0xf4/0x1d0

[  129.380047]  [<c025f558>] ? __debug_check_no_obj_freed+0x148/0x180

[  129.380047]  [<c025f52b>] ? __debug_check_no_obj_freed+0x11b/0x180

[  129.380047]  [<c025f52b>] ? __debug_check_no_obj_freed+0x11b/0x180

[  129.380047]  [<c01b01fb>] ? __d_free+0x2b/0x40

[  129.380047]  [<c03a2310>] ? sys_socketcall+0xb0/0x2a0

[  129.380047]  [<c01a209f>] ? fput+0x1f/0x30

[  129.380047]  [<c019ec67>] ? filp_close+0x47/0x70

[  129.380047]  [<c019ecfb>] ? sys_close+0x6b/0xc0

[  129.380047]  [<c0102e84>] ? sysenter_do_call+0x12/0x22

[  129.380047] Code: ca e8 57 ee 07 00 89 d8 83 c4 28 5b 5e 5f 5d c3 90
8d 74 26 00 83 6e 78 01 8b 13 8b 43 04 c7 03 00 00 00 00 c7 43 04 00 00
00 00 <89> 10 89 42 04 eb ca 8d 76 00 8b 86 ec 00 00 00 89 45 dc e9 6e



[  129.380047] EIP: [<c03aa18e>] __skb_recv_datagram+0xbe/0x210 SS:ESP
0068:f7215ce4

[  129.380047] CR2: 0000000000000000


[  129.380047] ---[ end trace 1eba78a3f87acfbf ]---




And when the daemon is not running, the following happens after loading
mac80211 and hostapd:



[  152.188692] BUG: unable to handle kernel NULL pointer dereference at
00000029
[  152.188876] IP: [<c03c8673>] netlink_unicast+0xc3/0x270

[  152.189016] *pde = 00000000

[  152.189141] Oops: 0000 [#1] SMP

[  152.189311] last sysfs file: /sys/devices/virtual/net/lo/operstate

[  152.189394] Modules linked in: mac80211_hwsim mac80211 cfg80211
netconsole
[  152.189718]
[  152.189793] Pid: 1979, comm: hostapd Not tainted (2.6.30-rc6 #29) 1000HE
[  152.189879] EIP: 0060:[<c03c8673>] EFLAGS: 00210202 CPU: 0
[  152.189963] EIP is at netlink_unicast+0xc3/0x270
[  152.190043] EAX: 00000000 EBX: f730c840 ECX: 00000000 EDX: 00000040
[  152.190127] ESI: 000000d0 EDI: f730c840 EBP: f7213ca0 ESP: f7213c80
[  152.190218]  DS: 007b ES: 007b FS: 00d8 GS: 0033 SS: 0068
[  152.190303] Process hostapd (pid: 1979, ti=f7212000 task=f7900420
task.ti=f7212000)
[  152.190404] Stack:
[  152.190476]  c03a7636 00000000 00000000 0000001c 00000000 00000000
f7308410 f7308424
[  152.190903]  f7213cc8 c03c8d0a 00000040 f7308400 f730c840 f730c840
f730c860 f7308400
[  152.191442]  f730c840 c03c9ab0 f7213cdc c03c8e61 f730c840 00000024
f730c840 f7213ce8
[  152.192044] Call Trace:
[  152.192047]  [<c03a7636>] ? __alloc_skb+0x46/0x120
[  152.192047]  [<c03c8d0a>] ? netlink_ack+0xba/0x180
[  152.192047]  [<c03c9ab0>] ? genl_rcv_msg+0x0/0x210
[  152.192047]  [<c03c8e61>] ? netlink_rcv_skb+0x91/0xa0
[  152.192047]  [<c03c9a9c>] ? genl_rcv+0x1c/0x30
[  152.192047]  [<c03c880f>] ? netlink_unicast+0x25f/0x270
[  152.192047]  [<c03c9611>] ? netlink_sendmsg+0x1c1/0x2b0
[  152.192047]  [<c03a1092>] ? sock_sendmsg+0xd2/0x100
[  152.192047]  [<c0141300>] ? autoremove_wake_function+0x0/0x50
[  152.192047]  [<c0141300>] ? autoremove_wake_function+0x0/0x50
[  152.192047]  [<c025f5a5>] ? debug_check_no_obj_freed+0x15/0x20
[  152.192047]  [<c025b311>] ? copy_from_user+0x31/0x80
[  152.192047]  [<c03a9c70>] ? verify_iovec+0x30/0xb0
[  152.192047]  [<c03a11d1>] ? sys_sendmsg+0x111/0x230
[  152.192047]  [<c025f3ef>] ? free_object+0x6f/0x90
[  152.192047]  [<c025f558>] ? __debug_check_no_obj_freed+0x148/0x180
[  152.192047]  [<c025f52b>] ? __debug_check_no_obj_freed+0x11b/0x180
[  152.192047]  [<c025f52b>] ? __debug_check_no_obj_freed+0x11b/0x180
[  152.192047]  [<c025f5a5>] ? debug_check_no_obj_freed+0x15/0x20
[  152.192047]  [<c01b01fb>] ? __d_free+0x2b/0x40
[  152.192047]  [<c03a232a>] ? sys_socketcall+0xca/0x2a0
[  152.192047]  [<c01a209f>] ? fput+0x1f/0x30
[  152.192047]  [<c019ec67>] ? filp_close+0x47/0x70
[  152.192047]  [<c019ecfb>] ? sys_close+0x6b/0xc0
[  152.192047]  [<c0102e84>] ? sysenter_do_call+0x12/0x22
[  152.192047] Code: 8b 4d ec 29 8f 98 00 00 00 eb 02 89 df 8b 55 08 31
c0 85 d2 75 09 8b 55 e8 8b 82 f0 00 00 00 89 45 f0 8d b6 00 00 00 00 8b
4d e8 <0f> b6 41 29 8b 71 24 6b d8 38 b8 90 b5 5a c0 03 1d 2c ee 6a c0
[  152.192047] EIP: [<c03c8673>] netlink_unicast+0xc3/0x270 SS:ESP
0068:f7213c80
[  152.192047] CR2: 0000000000000029
[  152.200339] ---[ end trace 9253b520506a5f83 ]---


So sending messages from userspace to kernel is working fine (HELO),
but not in the other direction from the TX handler.
I have no idea why there are NULL pointer dereferences in
__skb_recv_datagram and netlink_unicast.

Does anyone have an idea what I'm doing wrong?

Thank you.

Regards,
  Reiner

