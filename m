Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from www262.sakura.ne.jp ([202.181.97.72]:17423 "EHLO
        www262.sakura.ne.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751135AbeEGKOH (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Mon, 7 May 2018 06:14:07 -0400
Subject: Re: WARNING in add_uevent_var
To: Johannes Berg <johannes@sipsolutions.net>,
        syzbot <syzbot+230d9e642a85d3fec29c@syzkaller.appspotmail.com>,
        syzkaller-bugs@googlegroups.com
References: <000000000000a010b80568d75018@google.com>
 <1522758845.2961.3.camel@sipsolutions.net>
Cc: davem@davemloft.net, linux-kernel@vger.kernel.org,
        linux-wireless@vger.kernel.org, netdev@vger.kernel.org
From: Tetsuo Handa <penguin-kernel@I-love.SAKURA.ne.jp>
Message-ID: <1efbb9dc-e5a0-64d7-da3e-235852783f9c@I-love.SAKURA.ne.jp> (sfid-20180507_121425_092994_28511537)
Date: Mon, 7 May 2018 19:13:48 +0900
MIME-Version: 1.0
In-Reply-To: <1522758845.2961.3.camel@sipsolutions.net>
Content-Type: text/plain; charset=utf-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 2018/04/03 21:34, Johannes Berg wrote:
> On Sun, 2018-04-01 at 23:01 -0700, syzbot wrote:
> 
>> So far this crash happened 5 times on net-next, upstream.
>> C reproducer: https://syzkaller.appspot.com/x/repro.c?id=6614377067184128
>>
> 
> Huh, fun. Looks like you're basically creating a new HWSIM radio with an
> insanely long name (4k!) and nothing stops you, until we try to generate
> an rfkill instance which sends a uevent and only has a 2k buffer for the
> environment variables, where we put the name ...
> 
> But yeah, we should probably limit the phy name to something sane, I'll
> pick 128 and send a patch.
> 

I think it should be NAME_MAX.

----------------------------------------
#include <stdint.h>
#include <string.h>
#include <unistd.h>
#include <sys/socket.h>
#include <linux/netlink.h>

int main(int argc, char *argv[])
{
	const int fd = socket(PF_NETLINK, SOCK_RAW, NETLINK_GENERIC);
	static struct {
		struct nlmsghdr hdr;
		char data[4120 - sizeof(struct nlmsghdr)];
	} buf = { };
	struct sockaddr_nl addr = { .nl_family = AF_NETLINK };
	struct iovec iov = { &buf, sizeof(buf) };
	struct msghdr msg = {
		.msg_name = &addr,
		.msg_namelen = sizeof(addr),
		.msg_iov = &iov,
		.msg_iovlen = 1,
	};
	buf.hdr.nlmsg_len = 0x1018;
	buf.hdr.nlmsg_type = 0x22;
	buf.hdr.nlmsg_flags = 0x109;
	*(uint8_t*) buf.data = 4;
	*(uint8_t*) (buf.data + 1) = 0;
	*(uint16_t*) (buf.data + 2) = 0;
	*(uint16_t*) (buf.data + 4) = 0x1004;
	*(uint16_t*) (buf.data + 6) = 0x11;
	memset(buf.data + 8, 'A', 4096); /* strlen() > NAME_MAX */
	sendmsg(fd, &msg, 0);
	return 0;
}
----------------------------------------



>From 3eba6541da0c7338e3d71ea83cbc69962923d65e Mon Sep 17 00:00:00 2001
From: Tetsuo Handa <penguin-kernel@I-love.SAKURA.ne.jp>
Date: Mon, 7 May 2018 15:58:37 +0900
Subject: [PATCH] net: rfkill: Add filename varidity test at rfkill_alloc().

syzbot is hitting WARN() at kobject_uevent_env() [1].
This is because the test case is requesting too long name.
Since the name is used as part of pathname under /sys/devices/virtual/ ,
this name parameter must obey the limitations of a filename.
Fix this by applying name validity test to rfkill_alloc().

[1] https://syzkaller.appspot.com/bug?id=c1e1ab1d042b637ee9e25c64b107d51630b9d9ec

Signed-off-by: Tetsuo Handa <penguin-kernel@I-love.SAKURA.ne.jp>
Reported-by: syzbot <syzbot+230d9e642a85d3fec29c@syzkaller.appspotmail.com>
Cc: Johannes Berg <johannes@sipsolutions.net>
---
 net/rfkill/core.c | 4 ++++
 1 file changed, 4 insertions(+)

diff --git a/net/rfkill/core.c b/net/rfkill/core.c
index 59d0eb9..d8beebc 100644
--- a/net/rfkill/core.c
+++ b/net/rfkill/core.c
@@ -933,6 +933,10 @@ struct rfkill * __must_check rfkill_alloc(const char *name,
 	if (WARN_ON(type == RFKILL_TYPE_ALL || type >= NUM_RFKILL_TYPES))
 		return NULL;
 
+	if (strlen(name) > NAME_MAX || strchr(name, '/') ||
+	    !strcmp(name, ".") || !strcmp(name, ".."))
+		return NULL;
+
 	rfkill = kzalloc(sizeof(*rfkill) + strlen(name) + 1, GFP_KERNEL);
 	if (!rfkill)
 		return NULL;
-- 
1.8.3.1
