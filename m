Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from arroyo.ext.ti.com ([192.94.94.40]:47562 "EHLO arroyo.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755492Ab1IMIqu convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 13 Sep 2011 04:46:50 -0400
From: "Elias, Ilan" <ilane@ti.com>
To: "aloisio.almeida@openbossa.org" <aloisio.almeida@openbossa.org>,
	"lauro.venancio@openbossa.org" <lauro.venancio@openbossa.org>,
	"samuel@sortiz.org" <samuel@sortiz.org>,
	"linville@tuxdriver.com" <linville@tuxdriver.com>
CC: "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
Date: Tue, 13 Sep 2011 10:46:15 +0200
Subject: [PATCH v2 3/4] NFC: basic NCI protocol implementation
Message-ID: <AC090B9732AB2B4DB7FF476E907FE660013226A26C@dnce02.ent.ti.com> (sfid-20110913_104655_972947_1513D188)
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

The NFC Controller Interface (NCI) is a standard
communication protocol between an NFC Controller (NFCC)
and a Device Host (DH), defined by the NFC Forum.

Signed-off-by: Ilan Elias <ilane@ti.com>
---
 include/net/nfc/nci.h      |  313 ++++++++++++++++++
 include/net/nfc/nci_core.h |  183 ++++++++++
 net/nfc/Kconfig            |    2 +
 net/nfc/Makefile           |    1 +
 net/nfc/nci/Kconfig        |   10 +
 net/nfc/nci/Makefile       |    7 +
 net/nfc/nci/core.c         |  790 ++++++++++++++++++++++++++++++++++++++++++++
 net/nfc/nci/data.c         |  245 ++++++++++++++
 net/nfc/nci/lib.c          |   94 ++++++
 net/nfc/nci/ntf.c          |  258 +++++++++++++++
 net/nfc/nci/rsp.c          |  226 +++++++++++++
 11 files changed, 2129 insertions(+), 0 deletions(-)
 create mode 100644 include/net/nfc/nci.h
 create mode 100644 include/net/nfc/nci_core.h
 create mode 100644 net/nfc/nci/Kconfig
 create mode 100644 net/nfc/nci/Makefile
 create mode 100644 net/nfc/nci/core.c
 create mode 100644 net/nfc/nci/data.c
 create mode 100644 net/nfc/nci/lib.c
 create mode 100644 net/nfc/nci/ntf.c
 create mode 100644 net/nfc/nci/rsp.c

diff --git a/include/net/nfc/nci.h b/include/net/nfc/nci.h
new file mode 100644
index 0000000..39b85bc
--- /dev/null
+++ b/include/net/nfc/nci.h
@@ -0,0 +1,313 @@
+/*
+ *  The NFC Controller Interface is the communication protocol between an
+ *  NFC Controller (NFCC) and a Device Host (DH).
+ *
+ *  Copyright (C) 2011 Texas Instruments, Inc.
+ *
+ *  Written by Ilan Elias <ilane@ti.com>
+ *
+ *  Acknowledgements:
+ *  This file is based on hci.h, which was written
+ *  by Maxim Krasnyansky.
+ *
+ *  This program is free software; you can redistribute it and/or modify
+ *  it under the terms of the GNU General Public License version 2
+ *  as published by the Free Software Foundation
+ *
+ *  This program is distributed in the hope that it will be useful,
+ *  but WITHOUT ANY WARRANTY; without even the implied warranty of
+ *  MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
+ *  GNU General Public License for more details.
+ *
+ *  You should have received a copy of the GNU General Public License
+ *  along with this program; if not, write to the Free Software
+ *  Foundation, Inc., 59 Temple Place, Suite 330, Boston, MA  02111-1307  USA
+ *
+ */
+
+#ifndef __NCI_H
+#define __NCI_H
+
+/* NCI constants */
+#define NCI_MAX_NUM_MAPPING_CONFIGS                            10
+#define NCI_MAX_NUM_RF_CONFIGS                                 10
+#define NCI_MAX_NUM_CONN                                       10
+
+/* NCI Status Codes */
+#define        NCI_STATUS_OK                                           0x00
+#define        NCI_STATUS_REJECTED                                     0x01
+#define        NCI_STATUS_MESSAGE_CORRUPTED                            0x02
+#define        NCI_STATUS_BUFFER_FULL                                  0x03
+#define        NCI_STATUS_FAILED                                       0x04
+#define        NCI_STATUS_NOT_INITIALIZED                              0x05
+#define        NCI_STATUS_SYNTAX_ERROR                                 0x06
+#define        NCI_STATUS_SEMANTIC_ERROR                               0x07
+#define        NCI_STATUS_UNKNOWN_GID                                  0x08
+#define        NCI_STATUS_UNKNOWN_OID                                  0x09
+#define        NCI_STATUS_INVALID_PARAM                                0x0a
+#define        NCI_STATUS_MESSAGE_SIZE_EXCEEDED                        0x0b
+/* Discovery Specific Status Codes */
+#define        NCI_STATUS_DISCOVERY_ALREADY_STARTED                    0xa0
+#define        NCI_STATUS_DISCOVERY_TARGET_ACTIVATION_FAILED           0xa1
+/* RF Interface Specific Status Codes */
+#define        NCI_STATUS_RF_TRANSMISSION_ERROR                        0xb0
+#define        NCI_STATUS_RF_PROTOCOL_ERROR                            0xb1
+#define        NCI_STATUS_RF_TIMEOUT_ERROR                             0xb2
+#define        NCI_STATUS_RF_LINK_LOSS_ERROR                           0xb3
+/* NFCEE Interface Specific Status Codes */
+#define        NCI_STATUS_MAX_ACTIVE_NFCEE_INTERFACES_REACHED          0xc0
+#define        NCI_STATUS_NFCEE_INTERFACE_ACTIVATION_FAILED            0xc1
+#define        NCI_STATUS_NFCEE_TRANSMISSION_ERROR                     0xc2
+#define        NCI_STATUS_NFCEE_PROTOCOL_ERROR                         0xc3
+#define NCI_STATUS_NFCEE_TIMEOUT_ERROR                         0xc4
+
+/* NCI RF Technology and Mode */
+#define NCI_NFC_A_PASSIVE_POLL_MODE                            0x00
+#define NCI_NFC_B_PASSIVE_POLL_MODE                            0x01
+#define NCI_NFC_F_PASSIVE_POLL_MODE                            0x02
+#define NCI_NFC_A_ACTIVE_POLL_MODE                             0x03
+#define NCI_NFC_F_ACTIVE_POLL_MODE                             0x05
+#define NCI_NFC_A_PASSIVE_LISTEN_MODE                          0x80
+#define NCI_NFC_B_PASSIVE_LISTEN_MODE                          0x81
+#define NCI_NFC_F_PASSIVE_LISTEN_MODE                          0x82
+#define NCI_NFC_A_ACTIVE_LISTEN_MODE                           0x83
+#define NCI_NFC_F_ACTIVE_LISTEN_MODE                           0x85
+
+/* NCI RF Protocols */
+#define NCI_RF_PROTOCOL_UNKNOWN                                        0x00
+#define NCI_RF_PROTOCOL_T1T                                    0x01
+#define NCI_RF_PROTOCOL_T2T                                    0x02
+#define NCI_RF_PROTOCOL_T3T                                    0x03
+#define NCI_RF_PROTOCOL_ISO_DEP                                        0x04
+#define NCI_RF_PROTOCOL_NFC_DEP                                        0x05
+
+/* NCI RF Interfaces */
+#define NCI_RF_INTERFACE_RFU                                   0x00
+#define        NCI_RF_INTERFACE_FRAME                                  0x01
+#define        NCI_RF_INTERFACE_ISO_DEP                                0x02
+#define        NCI_RF_INTERFACE_NFC_DEP                                0x03
+
+/* NCI RF_DISCOVER_MAP_CMD modes */
+#define NCI_DISC_MAP_MODE_POLL                                 0x01
+#define NCI_DISC_MAP_MODE_LISTEN                               0x02
+#define NCI_DISC_MAP_MODE_BOTH                                 0x03
+
+/* NCI Discovery Types */
+#define NCI_DISCOVERY_TYPE_POLL_A_PASSIVE                      0x00
+#define        NCI_DISCOVERY_TYPE_POLL_B_PASSIVE                       0x01
+#define        NCI_DISCOVERY_TYPE_POLL_F_PASSIVE                       0x02
+#define        NCI_DISCOVERY_TYPE_POLL_A_ACTIVE                        0x03
+#define        NCI_DISCOVERY_TYPE_POLL_F_ACTIVE                        0x05
+#define        NCI_DISCOVERY_TYPE_WAKEUP_A_PASSIVE                     0x06
+#define        NCI_DISCOVERY_TYPE_WAKEUP_B_PASSIVE                     0x07
+#define        NCI_DISCOVERY_TYPE_WAKEUP_A_ACTIVE                      0x09
+#define        NCI_DISCOVERY_TYPE_LISTEN_A_PASSIVE                     0x80
+#define        NCI_DISCOVERY_TYPE_LISTEN_B_PASSIVE                     0x81
+#define        NCI_DISCOVERY_TYPE_LISTEN_F_PASSIVE                     0x82
+#define        NCI_DISCOVERY_TYPE_LISTEN_A_ACTIVE                      0x83
+#define        NCI_DISCOVERY_TYPE_LISTEN_F_ACTIVE                      0x85
+
+/* NCI Deactivation Type */
+#define        NCI_DEACTIVATE_TYPE_IDLE_MODE                           0x00
+#define        NCI_DEACTIVATE_TYPE_SLEEP_MODE                          0x01
+#define        NCI_DEACTIVATE_TYPE_SLEEP_AF_MODE                       0x02
+#define        NCI_DEACTIVATE_TYPE_RF_LINK_LOSS                        0x03
+#define        NCI_DEACTIVATE_TYPE_DISCOVERY_ERROR                     0x04
+
+/* Message Type (MT) */
+#define NCI_MT_DATA_PKT                                                0x00
+#define NCI_MT_CMD_PKT                                         0x01
+#define NCI_MT_RSP_PKT                                         0x02
+#define NCI_MT_NTF_PKT                                         0x03
+
+#define nci_mt(hdr)                    (((hdr)[0]>>5)&0x07)
+#define nci_mt_set(hdr, mt)            ((hdr)[0] |= (__u8)(((mt)&0x07)<<5))
+
+/* Packet Boundary Flag (PBF) */
+#define NCI_PBF_LAST                                           0x00
+#define NCI_PBF_CONT                                           0x01
+
+#define nci_pbf(hdr)                   (__u8)(((hdr)[0]>>4)&0x01)
+#define nci_pbf_set(hdr, pbf)          ((hdr)[0] |= (__u8)(((pbf)&0x01)<<4))
+
+/* Control Opcode manipulation */
+#define nci_opcode_pack(gid, oid)      (__u16)((((__u16)((gid)&0x0f))<<8)|\
+                                       ((__u16)((oid)&0x3f)))
+#define nci_opcode(hdr)                        nci_opcode_pack(hdr[0], hdr[1])
+#define nci_opcode_gid(op)             (__u8)(((op)&0x0f00)>>8)
+#define nci_opcode_oid(op)             (__u8)((op)&0x003f)
+
+/* Payload Length */
+#define nci_plen(hdr)                  (__u8)((hdr)[2])
+
+/* Connection ID */
+#define nci_conn_id(hdr)               (__u8)(((hdr)[0])&0x0f)
+
+/* GID values */
+#define        NCI_GID_CORE                                            0x0
+#define        NCI_GID_RF_MGMT                                         0x1
+#define        NCI_GID_NFCEE_MGMT                                      0x2
+#define        NCI_GID_PROPRIETARY                                     0xf
+
+/* ---- NCI Packet structures ---- */
+#define NCI_CTRL_HDR_SIZE                                      3
+#define NCI_DATA_HDR_SIZE                                      3
+
+struct nci_ctrl_hdr {
+       __u8    gid;            /* MT & PBF & GID */
+       __u8    oid;
+       __u8    plen;
+} __packed;
+
+struct nci_data_hdr {
+       __u8    conn_id;        /* MT & PBF & ConnID */
+       __u8    rfu;
+       __u8    plen;
+} __packed;
+
+/* ------------------------ */
+/* -----  NCI Commands ---- */
+/* ------------------------ */
+#define NCI_OP_CORE_RESET_CMD          nci_opcode_pack(NCI_GID_CORE, 0x00)
+
+#define NCI_OP_CORE_INIT_CMD           nci_opcode_pack(NCI_GID_CORE, 0x01)
+
+#define NCI_OP_CORE_SET_CONFIG_CMD     nci_opcode_pack(NCI_GID_CORE, 0x02)
+
+#define NCI_OP_CORE_CONN_CREATE_CMD    nci_opcode_pack(NCI_GID_CORE, 0x04)
+struct nci_core_conn_create_cmd {
+       __u8    target_handle;
+       __u8    num_target_specific_params;
+} __packed;
+
+#define NCI_OP_CORE_CONN_CLOSE_CMD     nci_opcode_pack(NCI_GID_CORE, 0x06)
+
+#define NCI_OP_RF_DISCOVER_MAP_CMD     nci_opcode_pack(NCI_GID_RF_MGMT, 0x00)
+struct disc_map_config {
+       __u8    rf_protocol;
+       __u8    mode;
+       __u8    rf_interface_type;
+} __packed;
+
+struct nci_rf_disc_map_cmd {
+       __u8                            num_mapping_configs;
+       struct disc_map_config          mapping_configs
+                                       [NCI_MAX_NUM_MAPPING_CONFIGS];
+} __packed;
+
+#define NCI_OP_RF_DISCOVER_CMD         nci_opcode_pack(NCI_GID_RF_MGMT, 0x03)
+struct disc_config {
+       __u8    type;
+       __u8    frequency;
+} __packed;
+
+struct nci_rf_disc_cmd {
+       __u8                            num_disc_configs;
+       struct disc_config              disc_configs[NCI_MAX_NUM_RF_CONFIGS];
+} __packed;
+
+#define NCI_OP_RF_DEACTIVATE_CMD       nci_opcode_pack(NCI_GID_RF_MGMT, 0x06)
+struct nci_rf_deactivate_cmd {
+       __u8    type;
+} __packed;
+
+/* ----------------------- */
+/* ---- NCI Responses ---- */
+/* ----------------------- */
+#define NCI_OP_CORE_RESET_RSP          nci_opcode_pack(NCI_GID_CORE, 0x00)
+struct nci_core_reset_rsp {
+       __u8    status;
+       __u8    nci_ver;
+} __packed;
+
+#define NCI_OP_CORE_INIT_RSP           nci_opcode_pack(NCI_GID_CORE, 0x01)
+struct nci_core_init_rsp_1 {
+       __u8    status;
+       __le32  nfcc_features;
+       __u8    num_supported_rf_interfaces;
+       __u8    supported_rf_interfaces[0];     /* variable size array */
+       /* continuted in nci_core_init_rsp_2 */
+} __packed;
+
+struct nci_core_init_rsp_2 {
+       __u8    max_logical_connections;
+       __le16  max_routing_table_size;
+       __u8    max_control_packet_payload_length;
+       __le16  rf_sending_buffer_size;
+       __le16  rf_receiving_buffer_size;
+       __le16  manufacturer_id;
+} __packed;
+
+#define NCI_OP_CORE_SET_CONFIG_RSP     nci_opcode_pack(NCI_GID_CORE, 0x02)
+
+#define NCI_OP_CORE_CONN_CREATE_RSP    nci_opcode_pack(NCI_GID_CORE, 0x04)
+struct nci_core_conn_create_rsp {
+       __u8    status;
+       __u8    max_pkt_payload_size;
+       __u8    initial_num_credits;
+       __u8    conn_id;
+} __packed;
+
+#define NCI_OP_CORE_CONN_CLOSE_RSP     nci_opcode_pack(NCI_GID_CORE, 0x06)
+
+#define NCI_OP_RF_DISCOVER_MAP_RSP     nci_opcode_pack(NCI_GID_RF_MGMT, 0x00)
+
+#define NCI_OP_RF_DISCOVER_RSP         nci_opcode_pack(NCI_GID_RF_MGMT, 0x03)
+
+#define NCI_OP_RF_DEACTIVATE_RSP       nci_opcode_pack(NCI_GID_RF_MGMT, 0x06)
+
+/* --------------------------- */
+/* ---- NCI Notifications ---- */
+/* --------------------------- */
+#define NCI_OP_CORE_CONN_CREDITS_NTF   nci_opcode_pack(NCI_GID_CORE, 0x07)
+struct conn_credit_entry {
+       __u8    conn_id;
+       __u8    credits;
+} __packed;
+
+struct nci_core_conn_credit_ntf {
+       __u8                            num_entries;
+       struct conn_credit_entry        conn_entries[NCI_MAX_NUM_CONN];
+} __packed;
+
+#define NCI_OP_RF_FIELD_INFO_NTF       nci_opcode_pack(NCI_GID_CORE, 0x08)
+struct nci_rf_field_info_ntf {
+       __u8    rf_field_status;
+} __packed;
+
+#define NCI_OP_RF_ACTIVATE_NTF         nci_opcode_pack(NCI_GID_RF_MGMT, 0x05)
+struct rf_tech_specific_params_nfca_poll {
+       __u16   sens_res;
+       __u8    nfcid1_len;     /* 0, 4, 7, or 10 Bytes */
+       __u8    nfcid1[10];
+       __u8    sel_res_len;    /* 0 or 1 Bytes */
+       __u8    sel_res;
+} __packed;
+
+struct activation_params_nfca_poll_iso_dep {
+       __u8    rats_res_len;
+       __u8    rats_res[20];
+};
+
+struct nci_rf_activate_ntf {
+       __u8    target_handle;
+       __u8    rf_protocol;
+       __u8    rf_tech_and_mode;
+       __u8    rf_tech_specific_params_len;
+
+       union {
+               struct rf_tech_specific_params_nfca_poll nfca_poll;
+       } rf_tech_specific_params;
+
+       __u8    rf_interface_type;
+       __u8    activation_params_len;
+
+       union {
+               struct activation_params_nfca_poll_iso_dep nfca_poll_iso_dep;
+       } activation_params;
+
+} __packed;
+
+#define NCI_OP_RF_DEACTIVATE_NTF       nci_opcode_pack(NCI_GID_RF_MGMT, 0x06)
+
+#endif /* __NCI_H */
diff --git a/include/net/nfc/nci_core.h b/include/net/nfc/nci_core.h
new file mode 100644
index 0000000..2563f3a
--- /dev/null
+++ b/include/net/nfc/nci_core.h
@@ -0,0 +1,183 @@
+/*
+ *  The NFC Controller Interface is the communication protocol between an
+ *  NFC Controller (NFCC) and a Device Host (DH).
+ *
+ *  Copyright (C) 2011 Texas Instruments, Inc.
+ *
+ *  Written by Ilan Elias <ilane@ti.com>
+ *
+ *  Acknowledgements:
+ *  This file is based on hci_core.h, which was written
+ *  by Maxim Krasnyansky.
+ *
+ *  This program is free software; you can redistribute it and/or modify
+ *  it under the terms of the GNU General Public License version 2
+ *  as published by the Free Software Foundation
+ *
+ *  This program is distributed in the hope that it will be useful,
+ *  but WITHOUT ANY WARRANTY; without even the implied warranty of
+ *  MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
+ *  GNU General Public License for more details.
+ *
+ *  You should have received a copy of the GNU General Public License
+ *  along with this program; if not, write to the Free Software
+ *  Foundation, Inc., 59 Temple Place, Suite 330, Boston, MA  02111-1307  USA
+ *
+ */
+
+#ifndef __NCI_CORE_H
+#define __NCI_CORE_H
+
+#include <linux/interrupt.h>
+#include <linux/skbuff.h>
+
+#include <net/nfc/nfc.h>
+#include <net/nfc/nci.h>
+
+/* NCI device state */
+enum {
+       NCI_INIT,
+       NCI_UP,
+       NCI_DISCOVERY,
+       NCI_POLL_ACTIVE,
+};
+
+/* NCI timeouts */
+#define NCI_RESET_TIMEOUT                      5000
+#define NCI_INIT_TIMEOUT                       5000
+#define NCI_RF_DISC_TIMEOUT                    5000
+#define NCI_RF_DEACTIVATE_TIMEOUT              5000
+#define NCI_CMD_TIMEOUT                                5000
+
+struct nci_dev;
+
+struct nci_ops {
+       int (*open)(struct nci_dev *ndev);
+       int (*close)(struct nci_dev *ndev);
+       int (*send)(struct sk_buff *skb);
+};
+
+#define NCI_MAX_SUPPORTED_RF_INTERFACES                4
+
+/* NCI Core structures */
+struct nci_dev {
+       struct nfc_dev          *nfc_dev;
+       struct nci_ops          *ops;
+
+       int                     tx_headroom;
+       int                     tx_tailroom;
+
+       unsigned long           flags;
+
+       atomic_t                cmd_cnt;
+       atomic_t                credits_cnt;
+
+       struct timer_list       cmd_timer;
+
+       struct workqueue_struct *cmd_wq;
+       struct work_struct      cmd_work;
+
+       struct workqueue_struct *rx_wq;
+       struct work_struct      rx_work;
+
+       struct workqueue_struct *tx_wq;
+       struct work_struct      tx_work;
+
+       struct sk_buff_head     cmd_q;
+       struct sk_buff_head     rx_q;
+       struct sk_buff_head     tx_q;
+
+       struct mutex            req_lock;
+       struct completion       req_completion;
+       __u32                   req_status;
+       __u32                   req_result;
+
+       void                    *driver_data;
+
+       __u32                   poll_prots;
+       __u32                   target_available_prots;
+       __u32                   target_active_prot;
+
+       /* received during NCI_OP_CORE_RESET_RSP */
+       __u8                    nci_ver;
+
+       /* received during NCI_OP_CORE_INIT_RSP */
+       __u32                   nfcc_features;
+       __u8                    num_supported_rf_interfaces;
+       __u8                    supported_rf_interfaces
+                               [NCI_MAX_SUPPORTED_RF_INTERFACES];
+       __u8                    max_logical_connections;
+       __u16                   max_routing_table_size;
+       __u8                    max_control_packet_payload_length;
+       __u16                   rf_sending_buffer_size;
+       __u16                   rf_receiving_buffer_size;
+       __u16                   manufacturer_id;
+
+       /* received during NCI_OP_CORE_CONN_CREATE_RSP for static conn 0 */
+       __u8                    max_pkt_payload_size;
+       __u8                    initial_num_credits;
+       __u8                    conn_id;
+
+       /* stored during nci_data_exchange */
+       data_exchange_cb_t      data_exchange_cb;
+       void                    *data_exchange_cb_context;
+       struct sk_buff          *rx_data_reassembly;
+};
+
+/* ----- NCI Devices ----- */
+struct nci_dev *nci_allocate_device(struct nci_ops *ops,
+                               __u32 supported_protocols,
+                               int tx_headroom,
+                               int tx_tailroom);
+void nci_free_device(struct nci_dev *ndev);
+int nci_register_device(struct nci_dev *ndev);
+void nci_unregister_device(struct nci_dev *ndev);
+int nci_recv_frame(struct sk_buff *skb);
+
+static inline struct sk_buff *nci_skb_alloc(struct nci_dev *ndev,
+                                               unsigned int len,
+                                               gfp_t how)
+{
+       struct sk_buff *skb;
+
+       skb = alloc_skb(len + ndev->tx_headroom + ndev->tx_tailroom, how);
+       if (skb)
+               skb_reserve(skb, ndev->tx_headroom);
+
+       return skb;
+}
+
+static inline void nci_set_parent_dev(struct nci_dev *ndev, struct device *dev)
+{
+       nfc_set_parent_dev(ndev->nfc_dev, dev);
+}
+
+static inline void nci_set_drvdata(struct nci_dev *ndev, void *data)
+{
+       ndev->driver_data = data;
+}
+
+static inline void *nci_get_drvdata(struct nci_dev *ndev)
+{
+       return ndev->driver_data;
+}
+
+void nci_rsp_packet(struct nci_dev *ndev, struct sk_buff *skb);
+void nci_ntf_packet(struct nci_dev *ndev, struct sk_buff *skb);
+void nci_rx_data_packet(struct nci_dev *ndev, struct sk_buff *skb);
+int nci_send_cmd(struct nci_dev *ndev, __u16 opcode, __u8 plen, void *payload);
+int nci_send_data(struct nci_dev *ndev, __u8 conn_id, struct sk_buff *skb);
+void nci_data_exchange_complete(struct nci_dev *ndev, struct sk_buff *skb,
+                               int err);
+
+/* ----- NCI requests ----- */
+#define NCI_REQ_DONE           0
+#define NCI_REQ_PEND           1
+#define NCI_REQ_CANCELED       2
+
+void nci_req_complete(struct nci_dev *ndev, int result);
+
+/* ----- NCI status code ----- */
+int nci_to_errno(__u8 code);
+
+#endif /* __NCI_CORE_H */
diff --git a/net/nfc/Kconfig b/net/nfc/Kconfig
index 33e095b..58cddad 100644
--- a/net/nfc/Kconfig
+++ b/net/nfc/Kconfig
@@ -13,4 +13,6 @@ menuconfig NFC
          To compile this support as a module, choose M here: the module will
          be called nfc.

+source "net/nfc/nci/Kconfig"
+
 source "drivers/nfc/Kconfig"
diff --git a/net/nfc/Makefile b/net/nfc/Makefile
index 16250c3..fbb550f 100644
--- a/net/nfc/Makefile
+++ b/net/nfc/Makefile
@@ -3,5 +3,6 @@
 #

 obj-$(CONFIG_NFC) += nfc.o
+obj-$(CONFIG_NFC_NCI) += nci/

 nfc-objs := core.o netlink.o af_nfc.o rawsock.o
diff --git a/net/nfc/nci/Kconfig b/net/nfc/nci/Kconfig
new file mode 100644
index 0000000..decdc49
--- /dev/null
+++ b/net/nfc/nci/Kconfig
@@ -0,0 +1,10 @@
+config NFC_NCI
+       depends on NFC && EXPERIMENTAL
+       tristate "NCI protocol support (EXPERIMENTAL)"
+       default n
+       help
+         NCI (NFC Controller Interface) is a communication protocol between
+         an NFC Controller (NFCC) and a Device Host (DH).
+
+         Say Y here to compile NCI support into the kernel or say M to
+         compile it as module (nci).
diff --git a/net/nfc/nci/Makefile b/net/nfc/nci/Makefile
new file mode 100644
index 0000000..cdb3a2e
--- /dev/null
+++ b/net/nfc/nci/Makefile
@@ -0,0 +1,7 @@
+#
+# Makefile for the Linux NFC NCI layer.
+#
+
+obj-$(CONFIG_NFC_NCI) += nci.o
+
+nci-objs := core.o data.o lib.o ntf.o rsp.o
\ No newline at end of file
diff --git a/net/nfc/nci/core.c b/net/nfc/nci/core.c
new file mode 100644
index 0000000..895e5fd
--- /dev/null
+++ b/net/nfc/nci/core.c
@@ -0,0 +1,790 @@
+/*
+ *  The NFC Controller Interface is the communication protocol between an
+ *  NFC Controller (NFCC) and a Device Host (DH).
+ *
+ *  Copyright (C) 2011 Texas Instruments, Inc.
+ *
+ *  Written by Ilan Elias <ilane@ti.com>
+ *
+ *  Acknowledgements:
+ *  This file is based on hci_core.c, which was written
+ *  by Maxim Krasnyansky.
+ *
+ *  This program is free software; you can redistribute it and/or modify
+ *  it under the terms of the GNU General Public License version 2
+ *  as published by the Free Software Foundation
+ *
+ *  This program is distributed in the hope that it will be useful,
+ *  but WITHOUT ANY WARRANTY; without even the implied warranty of
+ *  MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
+ *  GNU General Public License for more details.
+ *
+ *  You should have received a copy of the GNU General Public License
+ *  along with this program; if not, write to the Free Software
+ *  Foundation, Inc., 59 Temple Place, Suite 330, Boston, MA  02111-1307  USA
+ *
+ */
+
+#include <linux/types.h>
+#include <linux/workqueue.h>
+#include <linux/completion.h>
+#include <linux/sched.h>
+#include <linux/bitops.h>
+#include <linux/skbuff.h>
+
+#include "../nfc.h"
+#include <net/nfc/nci.h>
+#include <net/nfc/nci_core.h>
+#include <linux/nfc.h>
+
+static void nci_cmd_work(struct work_struct *work);
+static void nci_rx_work(struct work_struct *work);
+static void nci_tx_work(struct work_struct *work);
+
+/* ---- NCI requests ---- */
+
+void nci_req_complete(struct nci_dev *ndev, int result)
+{
+       if (ndev->req_status == NCI_REQ_PEND) {
+               ndev->req_result = result;
+               ndev->req_status = NCI_REQ_DONE;
+               complete(&ndev->req_completion);
+       }
+}
+
+static void nci_req_cancel(struct nci_dev *ndev, int err)
+{
+       if (ndev->req_status == NCI_REQ_PEND) {
+               ndev->req_result = err;
+               ndev->req_status = NCI_REQ_CANCELED;
+               complete(&ndev->req_completion);
+       }
+}
+
+/* Execute request and wait for completion. */
+static int __nci_request(struct nci_dev *ndev,
+       void (*req)(struct nci_dev *ndev, unsigned long opt),
+       unsigned long opt,
+       __u32 timeout)
+{
+       int rc = 0;
+       unsigned long completion_rc;
+
+       ndev->req_status = NCI_REQ_PEND;
+
+       init_completion(&ndev->req_completion);
+       req(ndev, opt);
+       completion_rc = wait_for_completion_interruptible_timeout(
+                                                       &ndev->req_completion,
+                                                       timeout);
+
+       nfc_dbg("wait_for_completion return %ld", completion_rc);
+
+       if (completion_rc > 0) {
+               switch (ndev->req_status) {
+               case NCI_REQ_DONE:
+                       rc = nci_to_errno(ndev->req_result);
+                       break;
+
+               case NCI_REQ_CANCELED:
+                       rc = -ndev->req_result;
+                       break;
+
+               default:
+                       rc = -ETIMEDOUT;
+                       break;
+               }
+       } else {
+               nfc_err("wait_for_completion_interruptible_timeout failed %ld",
+                       completion_rc);
+
+               rc = ((completion_rc == 0) ? (-ETIMEDOUT) : (completion_rc));
+       }
+
+       ndev->req_status = ndev->req_result = 0;
+
+       return rc;
+}
+
+static inline int nci_request(struct nci_dev *ndev,
+               void (*req)(struct nci_dev *ndev, unsigned long opt),
+               unsigned long opt, __u32 timeout)
+{
+       int rc;
+
+       if (!test_bit(NCI_UP, &ndev->flags))
+               return -ENETDOWN;
+
+       /* Serialize all requests */
+       mutex_lock(&ndev->req_lock);
+       rc = __nci_request(ndev, req, opt, timeout);
+       mutex_unlock(&ndev->req_lock);
+
+       return rc;
+}
+
+static void nci_reset_req(struct nci_dev *ndev, unsigned long opt)
+{
+       nci_send_cmd(ndev, NCI_OP_CORE_RESET_CMD, 0, NULL);
+}
+
+static void nci_init_req(struct nci_dev *ndev, unsigned long opt)
+{
+       nci_send_cmd(ndev, NCI_OP_CORE_INIT_CMD, 0, NULL);
+}
+
+static void nci_init_complete_req(struct nci_dev *ndev, unsigned long opt)
+{
+       struct nci_rf_disc_map_cmd cmd;
+       struct nci_core_conn_create_cmd conn_cmd;
+       int i;
+
+       /* create static rf connection */
+       conn_cmd.target_handle = 0;
+       conn_cmd.num_target_specific_params = 0;
+       nci_send_cmd(ndev, NCI_OP_CORE_CONN_CREATE_CMD, 2, &conn_cmd);
+
+       /* set rf mapping configurations */
+       cmd.num_mapping_configs = 0;
+
+       /* by default mapping is set to NCI_RF_INTERFACE_FRAME */
+       for (i = 0; i < ndev->num_supported_rf_interfaces; i++) {
+               if (ndev->supported_rf_interfaces[i] ==
+                       NCI_RF_INTERFACE_ISO_DEP) {
+                       cmd.mapping_configs[cmd.num_mapping_configs]
+                       .rf_protocol = NCI_RF_PROTOCOL_ISO_DEP;
+                       cmd.mapping_configs[cmd.num_mapping_configs]
+                       .mode = NCI_DISC_MAP_MODE_BOTH;
+                       cmd.mapping_configs[cmd.num_mapping_configs]
+                       .rf_interface_type = NCI_RF_INTERFACE_ISO_DEP;
+                       cmd.num_mapping_configs++;
+               } else if (ndev->supported_rf_interfaces[i] ==
+                       NCI_RF_INTERFACE_NFC_DEP) {
+                       cmd.mapping_configs[cmd.num_mapping_configs]
+                       .rf_protocol = NCI_RF_PROTOCOL_NFC_DEP;
+                       cmd.mapping_configs[cmd.num_mapping_configs]
+                       .mode = NCI_DISC_MAP_MODE_BOTH;
+                       cmd.mapping_configs[cmd.num_mapping_configs]
+                       .rf_interface_type = NCI_RF_INTERFACE_NFC_DEP;
+                       cmd.num_mapping_configs++;
+               }
+
+               if (cmd.num_mapping_configs == NCI_MAX_NUM_MAPPING_CONFIGS)
+                       break;
+       }
+
+       nci_send_cmd(ndev, NCI_OP_RF_DISCOVER_MAP_CMD,
+               (1 + (cmd.num_mapping_configs*sizeof(struct disc_map_config))),
+               &cmd);
+}
+
+static void nci_rf_discover_req(struct nci_dev *ndev, unsigned long opt)
+{
+       struct nci_rf_disc_cmd cmd;
+       __u32 protocols = opt;
+
+       cmd.num_disc_configs = 0;
+
+       if ((cmd.num_disc_configs < NCI_MAX_NUM_RF_CONFIGS) &&
+               (protocols & NFC_PROTO_JEWEL_MASK
+               || protocols & NFC_PROTO_MIFARE_MASK
+               || protocols & NFC_PROTO_ISO14443_MASK
+               || protocols & NFC_PROTO_NFC_DEP_MASK)) {
+               cmd.disc_configs[cmd.num_disc_configs].type =
+               NCI_DISCOVERY_TYPE_POLL_A_PASSIVE;
+               cmd.disc_configs[cmd.num_disc_configs].frequency = 1;
+               cmd.num_disc_configs++;
+       }
+
+       if ((cmd.num_disc_configs < NCI_MAX_NUM_RF_CONFIGS) &&
+               (protocols & NFC_PROTO_ISO14443_MASK)) {
+               cmd.disc_configs[cmd.num_disc_configs].type =
+               NCI_DISCOVERY_TYPE_POLL_B_PASSIVE;
+               cmd.disc_configs[cmd.num_disc_configs].frequency = 1;
+               cmd.num_disc_configs++;
+       }
+
+       if ((cmd.num_disc_configs < NCI_MAX_NUM_RF_CONFIGS) &&
+               (protocols & NFC_PROTO_FELICA_MASK
+               || protocols & NFC_PROTO_NFC_DEP_MASK)) {
+               cmd.disc_configs[cmd.num_disc_configs].type =
+               NCI_DISCOVERY_TYPE_POLL_F_PASSIVE;
+               cmd.disc_configs[cmd.num_disc_configs].frequency = 1;
+               cmd.num_disc_configs++;
+       }
+
+       nci_send_cmd(ndev, NCI_OP_RF_DISCOVER_CMD,
+               (1 + (cmd.num_disc_configs*sizeof(struct disc_config))),
+               &cmd);
+}
+
+static void nci_rf_deactivate_req(struct nci_dev *ndev, unsigned long opt)
+{
+       struct nci_rf_deactivate_cmd cmd;
+
+       cmd.type = NCI_DEACTIVATE_TYPE_IDLE_MODE;
+
+       nci_send_cmd(ndev, NCI_OP_RF_DEACTIVATE_CMD,
+                       sizeof(struct nci_rf_deactivate_cmd),
+                       &cmd);
+}
+
+static int nci_open_device(struct nci_dev *ndev)
+{
+       int rc = 0;
+
+       mutex_lock(&ndev->req_lock);
+
+       if (test_bit(NCI_UP, &ndev->flags)) {
+               rc = -EALREADY;
+               goto done;
+       }
+
+       if (ndev->ops->open(ndev)) {
+               rc = -EIO;
+               goto done;
+       }
+
+       atomic_set(&ndev->cmd_cnt, 1);
+
+       set_bit(NCI_INIT, &ndev->flags);
+
+       rc = __nci_request(ndev, nci_reset_req, 0,
+                               msecs_to_jiffies(NCI_RESET_TIMEOUT));
+
+       if (!rc) {
+               rc = __nci_request(ndev, nci_init_req, 0,
+                               msecs_to_jiffies(NCI_INIT_TIMEOUT));
+       }
+
+       if (!rc) {
+               rc = __nci_request(ndev, nci_init_complete_req, 0,
+                               msecs_to_jiffies(NCI_INIT_TIMEOUT));
+       }
+
+       clear_bit(NCI_INIT, &ndev->flags);
+
+       if (!rc) {
+               set_bit(NCI_UP, &ndev->flags);
+       } else {
+               /* Init failed, cleanup */
+               skb_queue_purge(&ndev->cmd_q);
+               skb_queue_purge(&ndev->rx_q);
+               skb_queue_purge(&ndev->tx_q);
+
+               ndev->ops->close(ndev);
+               ndev->flags = 0;
+       }
+
+done:
+       mutex_unlock(&ndev->req_lock);
+       return rc;
+}
+
+static int nci_close_device(struct nci_dev *ndev)
+{
+       nci_req_cancel(ndev, ENODEV);
+       mutex_lock(&ndev->req_lock);
+
+       if (!test_and_clear_bit(NCI_UP, &ndev->flags)) {
+               del_timer_sync(&ndev->cmd_timer);
+               mutex_unlock(&ndev->req_lock);
+               return 0;
+       }
+
+       /* Drop RX and TX queues */
+       skb_queue_purge(&ndev->rx_q);
+       skb_queue_purge(&ndev->tx_q);
+
+       /* Flush RX and TX wq */
+       flush_workqueue(ndev->rx_wq);
+       flush_workqueue(ndev->tx_wq);
+
+       /* Reset device */
+       skb_queue_purge(&ndev->cmd_q);
+       atomic_set(&ndev->cmd_cnt, 1);
+
+       set_bit(NCI_INIT, &ndev->flags);
+       __nci_request(ndev, nci_reset_req, 0,
+                               msecs_to_jiffies(NCI_RESET_TIMEOUT));
+       clear_bit(NCI_INIT, &ndev->flags);
+
+       /* Flush cmd wq */
+       flush_workqueue(ndev->cmd_wq);
+
+       /* After this point our queues are empty
+        * and no works are scheduled. */
+       ndev->ops->close(ndev);
+
+       /* Clear flags */
+       ndev->flags = 0;
+
+       mutex_unlock(&ndev->req_lock);
+
+       return 0;
+}
+
+/* NCI command timer function */
+static void nci_cmd_timer(unsigned long arg)
+{
+       struct nci_dev *ndev = (void *) arg;
+
+       nfc_dbg("entry");
+
+       atomic_set(&ndev->cmd_cnt, 1);
+       queue_work(ndev->cmd_wq, &ndev->cmd_work);
+}
+
+static int nci_dev_up(struct nfc_dev *nfc_dev)
+{
+       struct nci_dev *ndev = nfc_get_drvdata(nfc_dev);
+
+       nfc_dbg("entry");
+
+       return nci_open_device(ndev);
+}
+
+static int nci_dev_down(struct nfc_dev *nfc_dev)
+{
+       struct nci_dev *ndev = nfc_get_drvdata(nfc_dev);
+
+       nfc_dbg("entry");
+
+       return nci_close_device(ndev);
+}
+
+static int nci_start_poll(struct nfc_dev *nfc_dev, __u32 protocols)
+{
+       struct nci_dev *ndev = nfc_get_drvdata(nfc_dev);
+       int rc;
+
+       nfc_dbg("entry");
+
+       if (test_bit(NCI_DISCOVERY, &ndev->flags)) {
+               nfc_err("unable to start poll, since poll is already active");
+               return -EBUSY;
+       }
+
+       if (test_bit(NCI_POLL_ACTIVE, &ndev->flags)) {
+               nfc_dbg("target already active, first deactivate...");
+
+               rc = nci_request(ndev, nci_rf_deactivate_req, 0,
+                       msecs_to_jiffies(NCI_RF_DEACTIVATE_TIMEOUT));
+               if (rc)
+                       return -EBUSY;
+       }
+
+       rc = nci_request(ndev, nci_rf_discover_req, protocols,
+               msecs_to_jiffies(NCI_RF_DISC_TIMEOUT));
+
+       if (!rc)
+               ndev->poll_prots = protocols;
+
+       return rc;
+}
+
+static void nci_stop_poll(struct nfc_dev *nfc_dev)
+{
+       struct nci_dev *ndev = nfc_get_drvdata(nfc_dev);
+
+       nfc_dbg("entry");
+
+       if (!test_bit(NCI_DISCOVERY, &ndev->flags)) {
+               nfc_err("unable to stop poll, since poll is not active");
+               return;
+       }
+
+       nci_request(ndev, nci_rf_deactivate_req, 0,
+               msecs_to_jiffies(NCI_RF_DEACTIVATE_TIMEOUT));
+}
+
+static int nci_activate_target(struct nfc_dev *nfc_dev, __u32 target_idx,
+                               __u32 protocol)
+{
+       struct nci_dev *ndev = nfc_get_drvdata(nfc_dev);
+
+       nfc_dbg("entry, target_idx %d, protocol 0x%x", target_idx, protocol);
+
+       if (!test_bit(NCI_POLL_ACTIVE, &ndev->flags)) {
+               nfc_err("there is no available target to activate");
+               return -EINVAL;
+       }
+
+       if (ndev->target_active_prot) {
+               nfc_err("there is already an active target");
+               return -EBUSY;
+       }
+
+       if (!(ndev->target_available_prots & (1 << protocol))) {
+               nfc_err("target does not support the requested protocol 0x%x",
+                       protocol);
+               return -EINVAL;
+       }
+
+       ndev->target_active_prot = protocol;
+       ndev->target_available_prots = 0;
+
+       return 0;
+}
+
+static void nci_deactivate_target(struct nfc_dev *nfc_dev, __u32 target_idx)
+{
+       struct nci_dev *ndev = nfc_get_drvdata(nfc_dev);
+
+       nfc_dbg("entry, target_idx %d", target_idx);
+
+       if (!ndev->target_active_prot) {
+               nfc_err("unable to deactivate target, no active target");
+               return;
+       }
+
+       ndev->target_active_prot = 0;
+
+       if (test_bit(NCI_POLL_ACTIVE, &ndev->flags)) {
+               nci_request(ndev, nci_rf_deactivate_req, 0,
+                       msecs_to_jiffies(NCI_RF_DEACTIVATE_TIMEOUT));
+       }
+}
+
+static int nci_data_exchange(struct nfc_dev *nfc_dev, __u32 target_idx,
+                                               struct sk_buff *skb,
+                                               data_exchange_cb_t cb,
+                                               void *cb_context)
+{
+       struct nci_dev *ndev = nfc_get_drvdata(nfc_dev);
+
+       nfc_dbg("entry, target_idx %d, len %d", target_idx, skb->len);
+
+       if (!ndev->target_active_prot) {
+               nfc_err("unable to exchange data, no active target");
+               return -EINVAL;
+       }
+
+       /* store cb and context to be used on receiving data */
+       ndev->data_exchange_cb = cb;
+       ndev->data_exchange_cb_context = cb_context;
+
+       return nci_send_data(ndev, ndev->conn_id, skb);
+}
+
+static struct nfc_ops nci_nfc_ops = {
+       .dev_up = nci_dev_up,
+       .dev_down = nci_dev_down,
+       .start_poll = nci_start_poll,
+       .stop_poll = nci_stop_poll,
+       .activate_target = nci_activate_target,
+       .deactivate_target = nci_deactivate_target,
+       .data_exchange = nci_data_exchange,
+};
+
+/* ---- Interface to NCI drivers ---- */
+
+/**
+ * nci_allocate_device - allocate a new nci device
+ *
+ * @ops: device operations
+ * @supported_protocols: NFC protocols supported by the device
+ */
+struct nci_dev *nci_allocate_device(struct nci_ops *ops,
+                                       __u32 supported_protocols,
+                                       int tx_headroom,
+                                       int tx_tailroom)
+{
+       struct nci_dev *ndev = NULL;
+
+       nfc_dbg("entry, supported_protocols 0x%x", supported_protocols);
+
+       if (!ops->open || !ops->close || !ops->send)
+               goto exit;
+
+       if (!supported_protocols)
+               goto exit;
+
+       ndev = kzalloc(sizeof(struct nci_dev), GFP_KERNEL);
+       if (!ndev)
+               goto exit;
+
+       ndev->ops = ops;
+       ndev->tx_headroom = tx_headroom;
+       ndev->tx_tailroom = tx_tailroom;
+
+       ndev->nfc_dev = nfc_allocate_device(&nci_nfc_ops,
+                                               supported_protocols,
+                                               tx_headroom + NCI_DATA_HDR_SIZE,
+                                               tx_tailroom);
+       if (!ndev->nfc_dev)
+               goto free_exit;
+
+       nfc_set_drvdata(ndev->nfc_dev, ndev);
+
+       goto exit;
+
+free_exit:
+       kfree(ndev);
+
+exit:
+       return ndev;
+}
+EXPORT_SYMBOL(nci_allocate_device);
+
+/**
+ * nci_free_device - deallocate nci device
+ *
+ * @ndev: The nci device to deallocate
+ */
+void nci_free_device(struct nci_dev *ndev)
+{
+       nfc_dbg("entry");
+
+       nfc_free_device(ndev->nfc_dev);
+       kfree(ndev);
+}
+EXPORT_SYMBOL(nci_free_device);
+
+/**
+ * nci_register_device - register a nci device in the nfc subsystem
+ *
+ * @dev: The nci device to register
+ */
+int nci_register_device(struct nci_dev *ndev)
+{
+       int rc;
+       struct device *dev = &ndev->nfc_dev->dev;
+       char name[32];
+
+       nfc_dbg("entry");
+
+       rc = nfc_register_device(ndev->nfc_dev);
+       if (rc)
+               goto exit;
+
+       ndev->flags = 0;
+
+       INIT_WORK(&ndev->cmd_work, nci_cmd_work);
+       snprintf(name, sizeof(name), "%s_nci_cmd_wq", dev_name(dev));
+       ndev->cmd_wq = create_singlethread_workqueue(name);
+       if (!ndev->cmd_wq) {
+               rc = -ENOMEM;
+               goto unreg_exit;
+       }
+
+       INIT_WORK(&ndev->rx_work, nci_rx_work);
+       snprintf(name, sizeof(name), "%s_nci_rx_wq", dev_name(dev));
+       ndev->rx_wq = create_singlethread_workqueue(name);
+       if (!ndev->rx_wq) {
+               rc = -ENOMEM;
+               goto destroy_cmd_wq_exit;
+       }
+
+       INIT_WORK(&ndev->tx_work, nci_tx_work);
+       snprintf(name, sizeof(name), "%s_nci_tx_wq", dev_name(dev));
+       ndev->tx_wq = create_singlethread_workqueue(name);
+       if (!ndev->tx_wq) {
+               rc = -ENOMEM;
+               goto destroy_rx_wq_exit;
+       }
+
+       skb_queue_head_init(&ndev->cmd_q);
+       skb_queue_head_init(&ndev->rx_q);
+       skb_queue_head_init(&ndev->tx_q);
+
+       setup_timer(&ndev->cmd_timer, nci_cmd_timer,
+                       (unsigned long) ndev);
+
+       mutex_init(&ndev->req_lock);
+
+       goto exit;
+
+destroy_rx_wq_exit:
+       destroy_workqueue(ndev->rx_wq);
+
+destroy_cmd_wq_exit:
+       destroy_workqueue(ndev->cmd_wq);
+
+unreg_exit:
+       nfc_unregister_device(ndev->nfc_dev);
+
+exit:
+       return rc;
+}
+EXPORT_SYMBOL(nci_register_device);
+
+/**
+ * nci_unregister_device - unregister a nci device in the nfc subsystem
+ *
+ * @dev: The nci device to unregister
+ */
+void nci_unregister_device(struct nci_dev *ndev)
+{
+       nfc_dbg("entry");
+
+       nci_close_device(ndev);
+
+       destroy_workqueue(ndev->cmd_wq);
+       destroy_workqueue(ndev->rx_wq);
+       destroy_workqueue(ndev->tx_wq);
+
+       nfc_unregister_device(ndev->nfc_dev);
+}
+EXPORT_SYMBOL(nci_unregister_device);
+
+/**
+ * nci_recv_frame - receive frame from NCI drivers
+ *
+ * @skb: The sk_buff to receive
+ */
+int nci_recv_frame(struct sk_buff *skb)
+{
+       struct nci_dev *ndev = (struct nci_dev *) skb->dev;
+
+       nfc_dbg("entry, len %d", skb->len);
+
+       if (!ndev || (!test_bit(NCI_UP, &ndev->flags)
+               && !test_bit(NCI_INIT, &ndev->flags))) {
+               kfree_skb(skb);
+               return -ENXIO;
+       }
+
+       /* Queue frame for rx worker thread */
+       skb_queue_tail(&ndev->rx_q, skb);
+       queue_work(ndev->rx_wq, &ndev->rx_work);
+
+       return 0;
+}
+EXPORT_SYMBOL(nci_recv_frame);
+
+static int nci_send_frame(struct sk_buff *skb)
+{
+       struct nci_dev *ndev = (struct nci_dev *) skb->dev;
+
+       nfc_dbg("entry, len %d", skb->len);
+
+       if (!ndev) {
+               kfree_skb(skb);
+               return -ENODEV;
+       }
+
+       /* Get rid of skb owner, prior to sending to the driver. */
+       skb_orphan(skb);
+
+       return ndev->ops->send(skb);
+}
+
+/* Send NCI command */
+int nci_send_cmd(struct nci_dev *ndev, __u16 opcode, __u8 plen, void *payload)
+{
+       struct nci_ctrl_hdr *hdr;
+       struct sk_buff *skb;
+
+       nfc_dbg("entry, opcode 0x%x, plen %d", opcode, plen);
+
+       skb = nci_skb_alloc(ndev, (NCI_CTRL_HDR_SIZE + plen), GFP_KERNEL);
+       if (!skb) {
+               nfc_err("no memory for command");
+               return -ENOMEM;
+       }
+
+       hdr = (struct nci_ctrl_hdr *) skb_put(skb, NCI_CTRL_HDR_SIZE);
+       hdr->gid = nci_opcode_gid(opcode);
+       hdr->oid = nci_opcode_oid(opcode);
+       hdr->plen = plen;
+
+       nci_mt_set((__u8 *)hdr, NCI_MT_CMD_PKT);
+       nci_pbf_set((__u8 *)hdr, NCI_PBF_LAST);
+
+       if (plen)
+               memcpy(skb_put(skb, plen), payload, plen);
+
+       skb->dev = (void *) ndev;
+
+       skb_queue_tail(&ndev->cmd_q, skb);
+       queue_work(ndev->cmd_wq, &ndev->cmd_work);
+
+       return 0;
+}
+
+/* ---- NCI TX Data worker thread ---- */
+
+static void nci_tx_work(struct work_struct *work)
+{
+       struct nci_dev *ndev = container_of(work, struct nci_dev, tx_work);
+       struct sk_buff *skb;
+
+       nfc_dbg("entry, credits_cnt %d", atomic_read(&ndev->credits_cnt));
+
+       /* Send queued tx data */
+       while (atomic_read(&ndev->credits_cnt)) {
+               skb = skb_dequeue(&ndev->tx_q);
+               if (!skb)
+                       return;
+
+               atomic_dec(&ndev->credits_cnt);
+
+               nfc_dbg("NCI TX: MT=data, PBF=%d, conn_id=%d, plen=%d",
+                               nci_pbf(skb->data),
+                               nci_conn_id(skb->data),
+                               nci_plen(skb->data));
+
+               nci_send_frame(skb);
+       }
+}
+
+/* ----- NCI RX worker thread (data & control) ----- */
+
+static void nci_rx_work(struct work_struct *work)
+{
+       struct nci_dev *ndev = container_of(work, struct nci_dev, rx_work);
+       struct sk_buff *skb;
+
+       while ((skb = skb_dequeue(&ndev->rx_q))) {
+               /* Process frame */
+               switch (nci_mt(skb->data)) {
+               case NCI_MT_RSP_PKT:
+                       nci_rsp_packet(ndev, skb);
+                       break;
+
+               case NCI_MT_NTF_PKT:
+                       nci_ntf_packet(ndev, skb);
+                       break;
+
+               case NCI_MT_DATA_PKT:
+                       nci_rx_data_packet(ndev, skb);
+                       break;
+
+               default:
+                       nfc_err("unknown MT 0x%x", nci_mt(skb->data));
+                       kfree_skb(skb);
+                       break;
+               }
+       }
+}
+
+/* ----- NCI TX CMD worker thread ----- */
+
+static void nci_cmd_work(struct work_struct *work)
+{
+       struct nci_dev *ndev = container_of(work, struct nci_dev, cmd_work);
+       struct sk_buff *skb;
+
+       nfc_dbg("entry, cmd_cnt %d", atomic_read(&ndev->cmd_cnt));
+
+       /* Send queued command */
+       if (atomic_read(&ndev->cmd_cnt)) {
+               skb = skb_dequeue(&ndev->cmd_q);
+               if (!skb)
+                       return;
+
+               atomic_dec(&ndev->cmd_cnt);
+
+               nfc_dbg("NCI TX: MT=cmd, PBF=%d, GID=0x%x, OID=0x%x, plen=%d",
+                               nci_pbf(skb->data),
+                               nci_opcode_gid(nci_opcode(skb->data)),
+                               nci_opcode_oid(nci_opcode(skb->data)),
+                               nci_plen(skb->data));
+
+               nci_send_frame(skb);
+
+               mod_timer(&ndev->cmd_timer,
+                       jiffies + msecs_to_jiffies(NCI_CMD_TIMEOUT));
+       }
+}
diff --git a/net/nfc/nci/data.c b/net/nfc/nci/data.c
new file mode 100644
index 0000000..141790a
--- /dev/null
+++ b/net/nfc/nci/data.c
@@ -0,0 +1,245 @@
+/*
+ *  The NFC Controller Interface is the communication protocol between an
+ *  NFC Controller (NFCC) and a Device Host (DH).
+ *
+ *  Copyright (C) 2011 Texas Instruments, Inc.
+ *
+ *  Written by Ilan Elias <ilane@ti.com>
+ *
+ *  This program is free software; you can redistribute it and/or modify
+ *  it under the terms of the GNU General Public License version 2
+ *  as published by the Free Software Foundation
+ *
+ *  This program is distributed in the hope that it will be useful,
+ *  but WITHOUT ANY WARRANTY; without even the implied warranty of
+ *  MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
+ *  GNU General Public License for more details.
+ *
+ *  You should have received a copy of the GNU General Public License
+ *  along with this program; if not, write to the Free Software
+ *  Foundation, Inc., 59 Temple Place, Suite 330, Boston, MA  02111-1307  USA
+ *
+ */
+
+#include <linux/types.h>
+#include <linux/interrupt.h>
+#include <linux/wait.h>
+#include <linux/bitops.h>
+#include <linux/skbuff.h>
+
+#include "../nfc.h"
+#include <net/nfc/nci.h>
+#include <net/nfc/nci_core.h>
+#include <linux/nfc.h>
+
+/* Complete data exchange transaction and forward skb to nfc core */
+void nci_data_exchange_complete(struct nci_dev *ndev,
+                               struct sk_buff *skb,
+                               int err)
+{
+       data_exchange_cb_t cb = ndev->data_exchange_cb;
+       void *cb_context = ndev->data_exchange_cb_context;
+
+       nfc_dbg("entry, len %d, err %d", ((skb) ? (skb->len) : (0)), err);
+
+       if (cb) {
+               ndev->data_exchange_cb = NULL;
+               ndev->data_exchange_cb_context = 0;
+
+               /* forward skb to nfc core */
+               cb(cb_context, skb, err);
+       } else if (skb) {
+               nfc_err("no rx callback, dropping rx data...");
+
+               /* no waiting callback, free skb */
+               kfree_skb(skb);
+       }
+}
+
+/* ----------------- NCI TX Data ----------------- */
+
+static inline void nci_push_data_hdr(struct nci_dev *ndev,
+                                       __u8 conn_id,
+                                       struct sk_buff *skb,
+                                       __u8 pbf)
+{
+       struct nci_data_hdr *hdr;
+       int plen = skb->len;
+
+       hdr = (struct nci_data_hdr *) skb_push(skb, NCI_DATA_HDR_SIZE);
+       hdr->conn_id = conn_id;
+       hdr->rfu = 0;
+       hdr->plen = plen;
+
+       nci_mt_set((__u8 *)hdr, NCI_MT_DATA_PKT);
+       nci_pbf_set((__u8 *)hdr, pbf);
+
+       skb->dev = (void *) ndev;
+}
+
+static int nci_queue_tx_data_frags(struct nci_dev *ndev,
+                                       __u8 conn_id,
+                                       struct sk_buff *skb) {
+       int total_len = skb->len;
+       unsigned char *data = skb->data;
+       unsigned long flags;
+       struct sk_buff_head frags_q;
+       struct sk_buff *skb_frag;
+       int frag_len;
+       int rc = 0;
+
+       nfc_dbg("entry, conn_id 0x%x, total_len %d", conn_id, total_len);
+
+       __skb_queue_head_init(&frags_q);
+
+       while (total_len) {
+               frag_len = min_t(int, total_len, ndev->max_pkt_payload_size);
+
+               skb_frag = nci_skb_alloc(ndev,
+                                       (NCI_DATA_HDR_SIZE + frag_len),
+                                       GFP_KERNEL);
+               if (skb_frag == NULL) {
+                       rc = -ENOMEM;
+                       goto free_exit;
+               }
+               skb_reserve(skb_frag, NCI_DATA_HDR_SIZE);
+
+               /* first, copy the data */
+               memcpy(skb_put(skb_frag, frag_len), data, frag_len);
+
+               /* second, set the header */
+               nci_push_data_hdr(ndev, conn_id, skb_frag,
+               ((total_len == frag_len) ? (NCI_PBF_LAST) : (NCI_PBF_CONT)));
+
+               __skb_queue_tail(&frags_q, skb_frag);
+
+               data += frag_len;
+               total_len -= frag_len;
+
+               nfc_dbg("frag_len %d, remaining total_len %d",
+                       frag_len, total_len);
+       }
+
+       /* queue all fragments atomically */
+       spin_lock_irqsave(&ndev->tx_q.lock, flags);
+
+       while ((skb_frag = __skb_dequeue(&frags_q)) != NULL)
+               __skb_queue_tail(&ndev->tx_q, skb_frag);
+
+       spin_unlock_irqrestore(&ndev->tx_q.lock, flags);
+
+       /* free the original skb */
+       kfree_skb(skb);
+
+       goto exit;
+
+free_exit:
+       while ((skb_frag = __skb_dequeue(&frags_q)) != NULL)
+               kfree_skb(skb_frag);
+
+exit:
+       return rc;
+}
+
+/* Send NCI data */
+int nci_send_data(struct nci_dev *ndev, __u8 conn_id, struct sk_buff *skb)
+{
+       int rc = 0;
+
+       nfc_dbg("entry, conn_id 0x%x, plen %d", conn_id, skb->len);
+
+       /* check if the packet need to be fragmented */
+       if (skb->len <= ndev->max_pkt_payload_size) {
+               /* no need to fragment packet */
+               nci_push_data_hdr(ndev, conn_id, skb, NCI_PBF_LAST);
+
+               skb_queue_tail(&ndev->tx_q, skb);
+       } else {
+               /* fragment packet and queue the fragments */
+               rc = nci_queue_tx_data_frags(ndev, conn_id, skb);
+               if (rc) {
+                       nfc_err("failed to fragment tx data packet");
+                       goto free_exit;
+               }
+       }
+
+       queue_work(ndev->tx_wq, &ndev->tx_work);
+
+       goto exit;
+
+free_exit:
+       kfree_skb(skb);
+
+exit:
+       return rc;
+}
+
+/* ----------------- NCI RX Data ----------------- */
+
+static void nci_add_rx_data_frag(struct nci_dev *ndev,
+                               struct sk_buff *skb,
+                               __u8 pbf)
+{
+       int reassembly_len;
+       int err = 0;
+
+       if (ndev->rx_data_reassembly) {
+               reassembly_len = ndev->rx_data_reassembly->len;
+
+               /* first, make enough room for the already accumulated data */
+               if (skb_cow_head(skb, reassembly_len)) {
+                       nfc_err("error adding room for accumulated rx data");
+
+                       kfree_skb(skb);
+                       skb = 0;
+
+                       kfree_skb(ndev->rx_data_reassembly);
+                       ndev->rx_data_reassembly = 0;
+
+                       err = -ENOMEM;
+                       goto exit;
+               }
+
+               /* second, combine the two fragments */
+               memcpy(skb_push(skb, reassembly_len),
+                               ndev->rx_data_reassembly->data,
+                               reassembly_len);
+
+               /* third, free old reassembly */
+               kfree_skb(ndev->rx_data_reassembly);
+               ndev->rx_data_reassembly = 0;
+       }
+
+       if (pbf == NCI_PBF_CONT) {
+               /* need to wait for next fragment, store skb and exit */
+               ndev->rx_data_reassembly = skb;
+               return;
+       }
+
+exit:
+       nci_data_exchange_complete(ndev, skb, err);
+}
+
+/* Rx Data packet */
+void nci_rx_data_packet(struct nci_dev *ndev, struct sk_buff *skb)
+{
+       __u8 pbf = nci_pbf(skb->data);
+
+       nfc_dbg("entry, len %d", skb->len);
+
+       nfc_dbg("NCI RX: MT=data, PBF=%d, conn_id=%d, plen=%d",
+                       nci_pbf(skb->data),
+                       nci_conn_id(skb->data),
+                       nci_plen(skb->data));
+
+       /* strip the nci data header */
+       skb_pull(skb, NCI_DATA_HDR_SIZE);
+
+       if (ndev->target_active_prot == NFC_PROTO_MIFARE) {
+               /* frame I/F => remove the status byte */
+               nfc_dbg("NFC_PROTO_MIFARE => remove the status byte");
+               skb_trim(skb, (skb->len - 1));
+       }
+
+       nci_add_rx_data_frag(ndev, skb, pbf);
+}
diff --git a/net/nfc/nci/lib.c b/net/nfc/nci/lib.c
new file mode 100644
index 0000000..b19dc2f
--- /dev/null
+++ b/net/nfc/nci/lib.c
@@ -0,0 +1,94 @@
+/*
+ *  The NFC Controller Interface is the communication protocol between an
+ *  NFC Controller (NFCC) and a Device Host (DH).
+ *
+ *  Copyright (C) 2011 Texas Instruments, Inc.
+ *
+ *  Written by Ilan Elias <ilane@ti.com>
+ *
+ *  Acknowledgements:
+ *  This file is based on lib.c, which was written
+ *  by Maxim Krasnyansky.
+ *
+ *  This program is free software; you can redistribute it and/or modify
+ *  it under the terms of the GNU General Public License version 2
+ *  as published by the Free Software Foundation
+ *
+ *  This program is distributed in the hope that it will be useful,
+ *  but WITHOUT ANY WARRANTY; without even the implied warranty of
+ *  MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
+ *  GNU General Public License for more details.
+ *
+ *  You should have received a copy of the GNU General Public License
+ *  along with this program; if not, write to the Free Software
+ *  Foundation, Inc., 59 Temple Place, Suite 330, Boston, MA  02111-1307  USA
+ *
+ */
+
+#include <linux/module.h>
+#include <linux/kernel.h>
+#include <linux/types.h>
+#include <linux/errno.h>
+
+#include <net/nfc/nci.h>
+
+/* NCI status codes to Unix errno mapping */
+int nci_to_errno(__u8 code)
+{
+       switch (code) {
+       case NCI_STATUS_OK:
+               return 0;
+
+       case NCI_STATUS_REJECTED:
+               return -EBUSY;
+
+       case NCI_STATUS_MESSAGE_CORRUPTED:
+               return -EBADMSG;
+
+       case NCI_STATUS_BUFFER_FULL:
+               return -ENOBUFS;
+
+       case NCI_STATUS_NOT_INITIALIZED:
+               return -EHOSTDOWN;
+
+       case NCI_STATUS_SYNTAX_ERROR:
+       case NCI_STATUS_SEMANTIC_ERROR:
+       case NCI_STATUS_INVALID_PARAM:
+       case NCI_STATUS_RF_PROTOCOL_ERROR:
+       case NCI_STATUS_NFCEE_PROTOCOL_ERROR:
+               return -EPROTO;
+
+       case NCI_STATUS_UNKNOWN_GID:
+       case NCI_STATUS_UNKNOWN_OID:
+               return -EBADRQC;
+
+       case NCI_STATUS_MESSAGE_SIZE_EXCEEDED:
+               return -EMSGSIZE;
+
+       case NCI_STATUS_DISCOVERY_ALREADY_STARTED:
+               return -EALREADY;
+
+       case NCI_STATUS_DISCOVERY_TARGET_ACTIVATION_FAILED:
+       case NCI_STATUS_NFCEE_INTERFACE_ACTIVATION_FAILED:
+               return -ECONNREFUSED;
+
+       case NCI_STATUS_RF_TRANSMISSION_ERROR:
+       case NCI_STATUS_NFCEE_TRANSMISSION_ERROR:
+               return -ECOMM;
+
+       case NCI_STATUS_RF_TIMEOUT_ERROR:
+       case NCI_STATUS_NFCEE_TIMEOUT_ERROR:
+               return -ETIMEDOUT;
+
+       case NCI_STATUS_RF_LINK_LOSS_ERROR:
+               return -ENOLINK;
+
+       case NCI_STATUS_MAX_ACTIVE_NFCEE_INTERFACES_REACHED:
+               return -EDQUOT;
+
+       case NCI_STATUS_FAILED:
+       default:
+               return -ENOSYS;
+       }
+}
+EXPORT_SYMBOL(nci_to_errno);
diff --git a/net/nfc/nci/ntf.c b/net/nfc/nci/ntf.c
new file mode 100644
index 0000000..8dd7535
--- /dev/null
+++ b/net/nfc/nci/ntf.c
@@ -0,0 +1,258 @@
+/*
+ *  The NFC Controller Interface is the communication protocol between an
+ *  NFC Controller (NFCC) and a Device Host (DH).
+ *
+ *  Copyright (C) 2011 Texas Instruments, Inc.
+ *
+ *  Written by Ilan Elias <ilane@ti.com>
+ *
+ *  Acknowledgements:
+ *  This file is based on hci_event.c, which was written
+ *  by Maxim Krasnyansky.
+ *
+ *  This program is free software; you can redistribute it and/or modify
+ *  it under the terms of the GNU General Public License version 2
+ *  as published by the Free Software Foundation
+ *
+ *  This program is distributed in the hope that it will be useful,
+ *  but WITHOUT ANY WARRANTY; without even the implied warranty of
+ *  MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
+ *  GNU General Public License for more details.
+ *
+ *  You should have received a copy of the GNU General Public License
+ *  along with this program; if not, write to the Free Software
+ *  Foundation, Inc., 59 Temple Place, Suite 330, Boston, MA  02111-1307  USA
+ *
+ */
+
+#include <linux/types.h>
+#include <linux/interrupt.h>
+#include <linux/bitops.h>
+#include <linux/skbuff.h>
+
+#include "../nfc.h"
+#include <net/nfc/nci.h>
+#include <net/nfc/nci_core.h>
+#include <linux/nfc.h>
+
+/* Handle NCI Notification packets */
+
+static void nci_core_conn_credits_ntf_packet(struct nci_dev *ndev,
+                                               struct sk_buff *skb)
+{
+       struct nci_core_conn_credit_ntf *ntf = (void *) skb->data;
+       int i;
+
+       nfc_dbg("entry, num_entries %d", ntf->num_entries);
+
+       if (ntf->num_entries > NCI_MAX_NUM_CONN)
+               ntf->num_entries = NCI_MAX_NUM_CONN;
+
+       /* update the credits */
+       for (i = 0; i < ntf->num_entries; i++) {
+               nfc_dbg("entry[%d]: conn_id %d, credits %d", i,
+                       ntf->conn_entries[i].conn_id,
+                       ntf->conn_entries[i].credits);
+
+               if (ntf->conn_entries[i].conn_id == ndev->conn_id) {
+                       /* found static rf connection */
+                       atomic_add(ntf->conn_entries[i].credits,
+                               &ndev->credits_cnt);
+               }
+       }
+
+       /* trigger the next tx */
+       if (!skb_queue_empty(&ndev->tx_q))
+               queue_work(ndev->tx_wq, &ndev->tx_work);
+}
+
+static void nci_rf_field_info_ntf_packet(struct nci_dev *ndev,
+                                       struct sk_buff *skb)
+{
+       struct nci_rf_field_info_ntf *ntf = (void *) skb->data;
+
+       nfc_dbg("entry, rf_field_status %d", ntf->rf_field_status);
+}
+
+static int nci_rf_activate_nfca_passive_poll(struct nci_dev *ndev,
+                       struct nci_rf_activate_ntf *ntf, __u8 *data)
+{
+       struct rf_tech_specific_params_nfca_poll *nfca_poll;
+       struct activation_params_nfca_poll_iso_dep *nfca_poll_iso_dep;
+
+       nfca_poll = &ntf->rf_tech_specific_params.nfca_poll;
+       nfca_poll_iso_dep = &ntf->activation_params.nfca_poll_iso_dep;
+
+       nfca_poll->sens_res = __le16_to_cpu(*((__u16 *)data));
+       data += 2;
+
+       nfca_poll->nfcid1_len = *data++;
+
+       nfc_dbg("sens_res 0x%x, nfcid1_len %d",
+               nfca_poll->sens_res,
+               nfca_poll->nfcid1_len);
+
+       memcpy(nfca_poll->nfcid1, data, nfca_poll->nfcid1_len);
+       data += nfca_poll->nfcid1_len;
+
+       nfca_poll->sel_res_len = *data++;
+
+       if (nfca_poll->sel_res_len != 0)
+               nfca_poll->sel_res = *data++;
+
+       ntf->rf_interface_type = *data++;
+       ntf->activation_params_len = *data++;
+
+       nfc_dbg("sel_res_len %d, sel_res 0x%x, rf_interface_type %d, activation_params_len %d",
+               nfca_poll->sel_res_len,
+               nfca_poll->sel_res,
+               ntf->rf_interface_type,
+               ntf->activation_params_len);
+
+       switch (ntf->rf_interface_type) {
+       case NCI_RF_INTERFACE_ISO_DEP:
+               nfca_poll_iso_dep->rats_res_len = *data++;
+               if (nfca_poll_iso_dep->rats_res_len > 0) {
+                       memcpy(nfca_poll_iso_dep->rats_res,
+                               data,
+                               nfca_poll_iso_dep->rats_res_len);
+               }
+               break;
+
+       case NCI_RF_INTERFACE_FRAME:
+               /* no activation params */
+               break;
+
+       default:
+               nfc_err("unsupported rf_interface_type 0x%x",
+                       ntf->rf_interface_type);
+               return -EPROTO;
+       }
+
+       return 0;
+}
+
+static void nci_target_found(struct nci_dev *ndev,
+                               struct nci_rf_activate_ntf *ntf)
+{
+       struct nfc_target nfc_tgt;
+
+       if (ntf->rf_protocol == NCI_RF_PROTOCOL_T2T)    /* T2T MifareUL */
+               nfc_tgt.supported_protocols = NFC_PROTO_MIFARE_MASK;
+       else if (ntf->rf_protocol == NCI_RF_PROTOCOL_ISO_DEP)   /* 4A */
+               nfc_tgt.supported_protocols = NFC_PROTO_ISO14443_MASK;
+
+       nfc_tgt.sens_res = ntf->rf_tech_specific_params.nfca_poll.sens_res;
+       nfc_tgt.sel_res = ntf->rf_tech_specific_params.nfca_poll.sel_res;
+
+       if (!(nfc_tgt.supported_protocols & ndev->poll_prots)) {
+               nfc_dbg("the target found does not have the desired protocol");
+               return;
+       }
+
+       nfc_dbg("new target found,  supported_protocols 0x%x",
+               nfc_tgt.supported_protocols);
+
+       ndev->target_available_prots = nfc_tgt.supported_protocols;
+
+       nfc_targets_found(ndev->nfc_dev, &nfc_tgt, 1);
+}
+
+static void nci_rf_activate_ntf_packet(struct nci_dev *ndev,
+                                       struct sk_buff *skb)
+{
+       struct nci_rf_activate_ntf ntf;
+       __u8 *data = skb->data;
+       int rc = -1;
+
+       clear_bit(NCI_DISCOVERY, &ndev->flags);
+       set_bit(NCI_POLL_ACTIVE, &ndev->flags);
+
+       ntf.target_handle = *data++;
+       ntf.rf_protocol = *data++;
+       ntf.rf_tech_and_mode = *data++;
+       ntf.rf_tech_specific_params_len = *data++;
+
+       nfc_dbg("target_handle %d, rf_protocol 0x%x, rf_tech_and_mode 0x%x, rf_tech_specific_params_len %d",
+               ntf.target_handle,
+               ntf.rf_protocol,
+               ntf.rf_tech_and_mode,
+               ntf.rf_tech_specific_params_len);
+
+       switch (ntf.rf_tech_and_mode) {
+       case NCI_NFC_A_PASSIVE_POLL_MODE:
+               rc = nci_rf_activate_nfca_passive_poll(ndev, &ntf,
+                       data);
+               break;
+
+       default:
+               nfc_err("unsupported rf_tech_and_mode 0x%x",
+                       ntf.rf_tech_and_mode);
+               return;
+       }
+
+       if (!rc)
+               nci_target_found(ndev, &ntf);
+}
+
+static void nci_rf_deactivate_ntf_packet(struct nci_dev *ndev,
+                                       struct sk_buff *skb)
+{
+       __u8 type = skb->data[0];
+
+       nfc_dbg("entry, type 0x%x", type);
+
+       clear_bit(NCI_POLL_ACTIVE, &ndev->flags);
+       ndev->target_active_prot = 0;
+
+       /* drop tx data queue */
+       skb_queue_purge(&ndev->tx_q);
+
+       /* drop partial rx data packet */
+       if (ndev->rx_data_reassembly) {
+               kfree_skb(ndev->rx_data_reassembly);
+               ndev->rx_data_reassembly = 0;
+       }
+
+       /* complete the data exchange transaction, if exists */
+       if (ndev->data_exchange_cb)
+               nci_data_exchange_complete(ndev, NULL, -EIO);
+}
+
+void nci_ntf_packet(struct nci_dev *ndev, struct sk_buff *skb)
+{
+       __u16 ntf_opcode = nci_opcode(skb->data);
+
+       nfc_dbg("NCI RX: MT=ntf, PBF=%d, GID=0x%x, OID=0x%x, plen=%d",
+                       nci_pbf(skb->data),
+                       nci_opcode_gid(ntf_opcode),
+                       nci_opcode_oid(ntf_opcode),
+                       nci_plen(skb->data));
+
+       /* strip the nci control header */
+       skb_pull(skb, NCI_CTRL_HDR_SIZE);
+
+       switch (ntf_opcode) {
+       case NCI_OP_CORE_CONN_CREDITS_NTF:
+               nci_core_conn_credits_ntf_packet(ndev, skb);
+               break;
+
+       case NCI_OP_RF_FIELD_INFO_NTF:
+               nci_rf_field_info_ntf_packet(ndev, skb);
+               break;
+
+       case NCI_OP_RF_ACTIVATE_NTF:
+               nci_rf_activate_ntf_packet(ndev, skb);
+               break;
+
+       case NCI_OP_RF_DEACTIVATE_NTF:
+               nci_rf_deactivate_ntf_packet(ndev, skb);
+               break;
+
+       default:
+               nfc_err("unknown ntf opcode 0x%x", ntf_opcode);
+               break;
+       }
+
+       kfree_skb(skb);
+}
diff --git a/net/nfc/nci/rsp.c b/net/nfc/nci/rsp.c
new file mode 100644
index 0000000..0403d4c
--- /dev/null
+++ b/net/nfc/nci/rsp.c
@@ -0,0 +1,226 @@
+/*
+ *  The NFC Controller Interface is the communication protocol between an
+ *  NFC Controller (NFCC) and a Device Host (DH).
+ *
+ *  Copyright (C) 2011 Texas Instruments, Inc.
+ *
+ *  Written by Ilan Elias <ilane@ti.com>
+ *
+ *  Acknowledgements:
+ *  This file is based on hci_event.c, which was written
+ *  by Maxim Krasnyansky.
+ *
+ *  This program is free software; you can redistribute it and/or modify
+ *  it under the terms of the GNU General Public License version 2
+ *  as published by the Free Software Foundation
+ *
+ *  This program is distributed in the hope that it will be useful,
+ *  but WITHOUT ANY WARRANTY; without even the implied warranty of
+ *  MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
+ *  GNU General Public License for more details.
+ *
+ *  You should have received a copy of the GNU General Public License
+ *  along with this program; if not, write to the Free Software
+ *  Foundation, Inc., 59 Temple Place, Suite 330, Boston, MA  02111-1307  USA
+ *
+ */
+
+#include <linux/types.h>
+#include <linux/interrupt.h>
+#include <linux/bitops.h>
+#include <linux/skbuff.h>
+
+#include "../nfc.h"
+#include <net/nfc/nci.h>
+#include <net/nfc/nci_core.h>
+
+/* Handle NCI Response packets */
+
+static void nci_core_reset_rsp_packet(struct nci_dev *ndev, struct sk_buff *skb)
+{
+       struct nci_core_reset_rsp *rsp = (void *) skb->data;
+
+       nfc_dbg("entry, status 0x%x", rsp->status);
+
+       if (rsp->status == NCI_STATUS_OK)
+               ndev->nci_ver = rsp->nci_ver;
+
+       nfc_dbg("nci_ver 0x%x", ndev->nci_ver);
+
+       nci_req_complete(ndev, rsp->status);
+}
+
+static void nci_core_init_rsp_packet(struct nci_dev *ndev, struct sk_buff *skb)
+{
+       struct nci_core_init_rsp_1 *rsp_1 = (void *) skb->data;
+       struct nci_core_init_rsp_2 *rsp_2;
+
+       nfc_dbg("entry, status 0x%x", rsp_1->status);
+
+       if (rsp_1->status != NCI_STATUS_OK)
+               return;
+
+       ndev->nfcc_features = __le32_to_cpu(rsp_1->nfcc_features);
+       ndev->num_supported_rf_interfaces = rsp_1->num_supported_rf_interfaces;
+
+       if (ndev->num_supported_rf_interfaces >
+               NCI_MAX_SUPPORTED_RF_INTERFACES) {
+               ndev->num_supported_rf_interfaces =
+                       NCI_MAX_SUPPORTED_RF_INTERFACES;
+       }
+
+       memcpy(ndev->supported_rf_interfaces,
+               rsp_1->supported_rf_interfaces,
+               ndev->num_supported_rf_interfaces);
+
+       rsp_2 = (void *) (skb->data + 6 + ndev->num_supported_rf_interfaces);
+
+       ndev->max_logical_connections =
+               rsp_2->max_logical_connections;
+       ndev->max_routing_table_size =
+               __le16_to_cpu(rsp_2->max_routing_table_size);
+       ndev->max_control_packet_payload_length =
+               rsp_2->max_control_packet_payload_length;
+       ndev->rf_sending_buffer_size =
+               __le16_to_cpu(rsp_2->rf_sending_buffer_size);
+       ndev->rf_receiving_buffer_size =
+               __le16_to_cpu(rsp_2->rf_receiving_buffer_size);
+       ndev->manufacturer_id =
+               __le16_to_cpu(rsp_2->manufacturer_id);
+
+       nfc_dbg("nfcc_features 0x%x",
+               ndev->nfcc_features);
+       nfc_dbg("num_supported_rf_interfaces %d",
+               ndev->num_supported_rf_interfaces);
+       nfc_dbg("supported_rf_interfaces[0] 0x%x",
+               ndev->supported_rf_interfaces[0]);
+       nfc_dbg("supported_rf_interfaces[1] 0x%x",
+               ndev->supported_rf_interfaces[1]);
+       nfc_dbg("supported_rf_interfaces[2] 0x%x",
+               ndev->supported_rf_interfaces[2]);
+       nfc_dbg("supported_rf_interfaces[3] 0x%x",
+               ndev->supported_rf_interfaces[3]);
+       nfc_dbg("max_logical_connections %d",
+               ndev->max_logical_connections);
+       nfc_dbg("max_routing_table_size %d",
+               ndev->max_routing_table_size);
+       nfc_dbg("max_control_packet_payload_length %d",
+               ndev->max_control_packet_payload_length);
+       nfc_dbg("rf_sending_buffer_size %d",
+               ndev->rf_sending_buffer_size);
+       nfc_dbg("rf_receiving_buffer_size %d",
+               ndev->rf_receiving_buffer_size);
+       nfc_dbg("manufacturer_id 0x%x",
+               ndev->manufacturer_id);
+
+       nci_req_complete(ndev, rsp_1->status);
+}
+
+static void nci_core_conn_create_rsp_packet(struct nci_dev *ndev,
+                                               struct sk_buff *skb)
+{
+       struct nci_core_conn_create_rsp *rsp = (void *) skb->data;
+
+       nfc_dbg("entry, status 0x%x", rsp->status);
+
+       if (rsp->status != NCI_STATUS_OK)
+               return;
+
+       ndev->max_pkt_payload_size = rsp->max_pkt_payload_size;
+       ndev->initial_num_credits = rsp->initial_num_credits;
+       ndev->conn_id = rsp->conn_id;
+
+       atomic_set(&ndev->credits_cnt, ndev->initial_num_credits);
+
+       nfc_dbg("max_pkt_payload_size %d", ndev->max_pkt_payload_size);
+       nfc_dbg("initial_num_credits %d", ndev->initial_num_credits);
+       nfc_dbg("conn_id %d", ndev->conn_id);
+}
+
+static void nci_rf_disc_map_rsp_packet(struct nci_dev *ndev,
+                                       struct sk_buff *skb)
+{
+       __u8 status = skb->data[0];
+
+       nfc_dbg("entry, status 0x%x", status);
+
+       nci_req_complete(ndev, status);
+}
+
+static void nci_rf_disc_rsp_packet(struct nci_dev *ndev, struct sk_buff *skb)
+{
+       __u8 status = skb->data[0];
+
+       nfc_dbg("entry, status 0x%x", status);
+
+       if (status == NCI_STATUS_OK)
+               set_bit(NCI_DISCOVERY, &ndev->flags);
+
+       nci_req_complete(ndev, status);
+}
+
+static void nci_rf_deactivate_rsp_packet(struct nci_dev *ndev,
+                                       struct sk_buff *skb)
+{
+       __u8 status = skb->data[0];
+
+       nfc_dbg("entry, status 0x%x", status);
+
+       clear_bit(NCI_DISCOVERY, &ndev->flags);
+
+       nci_req_complete(ndev, status);
+}
+
+void nci_rsp_packet(struct nci_dev *ndev, struct sk_buff *skb)
+{
+       __u16 rsp_opcode = nci_opcode(skb->data);
+
+       /* we got a rsp, stop the cmd timer */
+       del_timer(&ndev->cmd_timer);
+
+       nfc_dbg("NCI RX: MT=rsp, PBF=%d, GID=0x%x, OID=0x%x, plen=%d",
+                       nci_pbf(skb->data),
+                       nci_opcode_gid(rsp_opcode),
+                       nci_opcode_oid(rsp_opcode),
+                       nci_plen(skb->data));
+
+       /* strip the nci control header */
+       skb_pull(skb, NCI_CTRL_HDR_SIZE);
+
+       switch (rsp_opcode) {
+       case NCI_OP_CORE_RESET_RSP:
+               nci_core_reset_rsp_packet(ndev, skb);
+               break;
+
+       case NCI_OP_CORE_INIT_RSP:
+               nci_core_init_rsp_packet(ndev, skb);
+               break;
+
+       case NCI_OP_CORE_CONN_CREATE_RSP:
+               nci_core_conn_create_rsp_packet(ndev, skb);
+               break;
+
+       case NCI_OP_RF_DISCOVER_MAP_RSP:
+               nci_rf_disc_map_rsp_packet(ndev, skb);
+               break;
+
+       case NCI_OP_RF_DISCOVER_RSP:
+               nci_rf_disc_rsp_packet(ndev, skb);
+               break;
+
+       case NCI_OP_RF_DEACTIVATE_RSP:
+               nci_rf_deactivate_rsp_packet(ndev, skb);
+               break;
+
+       default:
+               nfc_err("unknown rsp opcode 0x%x", rsp_opcode);
+               break;
+       }
+
+       kfree_skb(skb);
+
+       /* trigger the next cmd */
+       atomic_set(&ndev->cmd_cnt, 1);
+       if (!skb_queue_empty(&ndev->cmd_q))
+               queue_work(ndev->cmd_wq, &ndev->cmd_work);
+}
--
1.7.0.4
